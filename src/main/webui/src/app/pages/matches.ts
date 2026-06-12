import { httpResource } from '@angular/common/http';
import { afterRenderEffect, Component, computed, inject, signal } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { MatchCard } from '@components/match-card';
import { MatchCardSkeleton } from '@components/match-card-skeleton';
import { MatchStageFilter } from '@components/match-stage-filter';
import { Bet, PagedResponse } from '@interfaces/index';
import { Match } from '@interfaces/match.interface';
import { MatchStage } from '@interfaces/match-stage.enum';
import { BolaoModule } from '@modules/bolao/bolao.module';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'matches',
  imports: [BolaoModule, MatchCard, MatchCardSkeleton, MatchStageFilter, TranslocoPipe],
  templateUrl: './matches.html',
})
export class Matches {
  private readonly store = inject(SignalStore);
  private userId = computed(() => this.store.appuser()?.id);

  matchesPage = httpResource<PagedResponse<Match>>(() => API.MATCHES.GET_ALL(this.userId(), 0, 200));
  betsPage = httpResource<PagedResponse<Bet>>(() => API.BETS.GET_ALL(0, 10000));

  matches = computed(() => this.matchesPage.value()?.content ?? []);
  bets = computed(() => this.betsPage.value()?.content ?? []);

  activeStage = signal<MatchStage | null>(null);

  filteredMatches = computed(() => {
    const all = this.matches();
    const stage = this.activeStage();
    return stage ? all.filter(m => m.stage === stage) : all;
  });

  onStageChange(stage: MatchStage | null) {
    this.activeStage.set(stage);
  }

  _ = afterRenderEffect(() => {
    if (this.matchesPage.hasValue() && this.betsPage.hasValue() && !this.activeStage()) {
      const dateAnchor = new Date().toISOString().split('T')[0];
      const element = document.getElementById(dateAnchor);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  });

  getBetForMatch(match: Match): Bet | undefined {
    return match.userBet?.id ? match.userBet : undefined;
  }
}
