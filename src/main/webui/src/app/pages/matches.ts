import { afterRenderEffect, Component, computed, inject, signal } from '@angular/core';
import { MatchCard } from '@components/match-card';
import { MatchCardSkeleton } from '@components/match-card-skeleton';
import { MatchStageFilter } from '@components/match-stage-filter';
import { MatchStage } from '@interfaces/match-stage.enum';
import { TranslocoPipe } from '@jsverse/transloco';
import { BolaoModule } from '@modules/bolao/bolao.module';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'matches',
  imports: [BolaoModule, MatchCard, MatchCardSkeleton, MatchStageFilter, TranslocoPipe],
  templateUrl: './matches.html',
})
export class Matches {
  protected readonly store = inject(SignalStore);
  private userId = computed(() => this.store.appuser()?.id);

  matches = this.store.allMatches;
  bets = this.store.allBets;

  activeStage = signal<MatchStage | null>(null);

  filteredMatches = computed(() => {
    const all = this.matches();
    const stage = this.activeStage();
    return stage ? all.filter((m) => m.stage === stage) : all;
  });

  onStageChange(stage: MatchStage | null) {
    this.activeStage.set(stage);
  }

  _ = afterRenderEffect(() => {
    if (!this.activeStage()) {
      const dateAnchor = new Date().toISOString().split('T')[0];
      const element = document.getElementById(dateAnchor);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  });
}
