import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { API } from '@api/api';
import { ChampionBet } from '@interfaces/champion-bet.interface';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';
import { resourceValueOr404 } from '../utils/resource-utils';

@Component({
  selector: 'bonus-bets-champions-alert',
  imports: [TranslocoPipe, RouterLink],
  template: `
    @if (!championBetComplete()) {
      <div class="col-span-full flex flex-col gap-3">
        <a
          routerLink="/champion-bet"
          class="flex items-center gap-3 px-4 py-3 rounded-xl border border-secondary-200 bg-secondary-50 hover:bg-secondary-100 transition-colors cursor-pointer"
        >
          <span class="text-2xl">🏆</span>
          <div class="flex-1">
            <span class="font-bold text-secondary-700">{{ 'championBet.title' | transloco }}</span>
            <p class="text-xs text-gray-500">{{ 'dashboard.championBetLink' | transloco }}</p>
          </div>
          <span class="ml-auto text-secondary-400">→</span>
        </a>
      </div>
    }
  `,
  styles: ``,
})
export class BonusBetsChampionsAlert {
  readonly store = inject(SignalStore);
  userId = computed(() => this.store.appuser()?.id);

  championBetResource = httpResource<ChampionBet | null>(() => {
    const id = this.userId();
    return id ? API.CHAMPION_BETS.GET_BY_USER(id) : undefined;
  });
  championBetComplete = computed(() => {
    const bet = resourceValueOr404(this.championBetResource);
    if (!bet) return false;
    return !!(
      bet.championTeamId &&
      bet.runnerUpTeamId &&
      bet.semifinalist1TeamId &&
      bet.semifinalist2TeamId &&
      bet.semifinalist3TeamId &&
      bet.semifinalist4TeamId
    );
  });
}
