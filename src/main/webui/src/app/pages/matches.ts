import { httpResource } from '@angular/common/http';
import { afterRenderEffect, Component, computed, inject, signal } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { MatchCard } from '@components/match-card';
import { MatchStageFilter } from '@components/match-stage-filter';
import { Bet } from '@interfaces/index';
import { Match } from '@interfaces/match.interface';
import { MatchStage } from '@interfaces/match-stage.enum';
import { BolaoModule } from '@modules/bolao/bolao.module';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'matches',
  imports: [BolaoModule, MatchCard, MatchStageFilter, TranslocoPipe],
  templateUrl: './matches.html',
})
export class Matches {
  private readonly store = inject(SignalStore);
  private userId = computed(() => this.store.appuser()?.id);

  matches = httpResource<Match[]>(() => API.MATCHES.GET_ALL(this.userId()));
  bets = httpResource<Bet[]>(() => API.BETS.GET_ALL());

  activeStage = signal<MatchStage | null>(null);

  filteredMatches = computed(() => {
    const all = this.matches.value() ?? [];
    const stage = this.activeStage();
    return stage ? all.filter(m => m.stage === stage) : all;
  });

  onStageChange(stage: MatchStage | null) {
    this.activeStage.set(stage);
  }

  _ = afterRenderEffect(() => {
    if (this.matches.hasValue() && this.bets.hasValue() && !this.activeStage()) {
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
