import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { API } from '@api/api';
import { GroupWinnerBet } from '@interfaces/group-winner-bet.interface';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'bonus-bets-groups-alert',
  imports: [TranslocoPipe, RouterLink],
  template: `
    @if (!groupBetsComplete()) {
      <div class="col-span-full flex flex-col gap-3">
        <a
          routerLink="/group-bets"
          class="flex items-center gap-3 px-4 py-3 rounded-xl border border-secondary-200 bg-secondary-50 hover:bg-secondary-100 transition-colors cursor-pointer"
        >
          <span class="text-2xl">🏅</span>
          <div class="flex-1">
            <span class="font-bold text-primary-700">{{
              'groupWinnerBets.title' | transloco
            }}</span>
            <p class="text-xs text-gray-500">{{ 'dashboard.groupBetsLink' | transloco }}</p>
          </div>
          <span class="ml-auto text-primary-400">→</span>
        </a>
      </div>
    }
  `,
  styles: ``,
})
export class BonusBetsGroupsAlert {
  readonly store = inject(SignalStore);
  userId = computed(() => this.store.appuser()?.id);

  groupBets = httpResource<GroupWinnerBet[]>(() => {
    const id = this.userId();
    return id ? API.GROUP_WINNER_BETS.GET_BY_USER(id) : undefined;
  });
  groupBetsComplete = computed(() => (this.groupBets.value()?.length ?? 0) >= 12);
}
