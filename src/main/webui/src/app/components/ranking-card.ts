import { Component, computed, inject, input } from '@angular/core';
import { RouterLink } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'ranking-card',
  imports: [TranslocoPipe, RouterLink],
  template: `
    <div class="flex flex-col border border-gray-200 dark:border-gray-700 rounded-t-xl">
      <div class="border-b border-gray-200 dark:border-gray-700 -mx-4 p-4">
        <a routerLink="/ranking" class="text-lg sm:text-xl font-bold text-primary-700 dark:text-primary-300 hover:underline">
          {{ 'dashboard.ranking.title' | transloco }}
        </a>
      </div>
      <div class="p-0">
        @if (displayEntries().length === 0) {
          <p class="text-sm opacity-60 px-3 py-2">{{ 'dashboard.ranking.noData' | transloco }}</p>
        } @else {
          <div class="flex flex-col">
            @for (entry of displayEntries(); track entry.userId) {
              <div
                class="flex items-center gap-3 px-3 sm:px-4 py-2 sm:py-2.5 transition-colors"
                [class.bg-primary-100]="entry.userId === currentUserId()"
                [class.dark:bg-primary-900]="entry.userId === currentUserId()"
                [class.font-bold]="entry.userId === currentUserId()"
                [class.bg-gray-50]="entry.userId !== currentUserId()"
                [class.dark:bg-gray-800]="entry.userId !== currentUserId()"
              >
                <div
                  class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold text-white"
                  [class.bg-yellow-500]="entry.position === 1"
                  [class.bg-gray-400]="entry.position === 2"
                  [class.bg-amber-700]="entry.position === 3"
                  [class.bg-gray-300]="entry.position > 3"
                  [class.!text-gray-600]="entry.position > 3"
                >
                  {{ entry.position }}
                </div>
                <span class="flex-1 text-sm sm:text-base truncate"><a [routerLink]="['/bets', entry.userId]" class="hover:underline text-inherit">{{ entry.userName }}</a></span>
                @if (entry.separator) {
                  <span class="text-xs opacity-40">⋯</span>
                }
                <span class="text-sm sm:text-base font-mono tabular-nums">{{
                  entry.totalPoints
                }}</span>
                <span class="text-xs opacity-50">{{ 'matchSchedule.points' | transloco }}</span>
              </div>
            }
          </div>
        }
      </div>
    </div>
  `,
  styles: ``,
})
export class RankingCard {
  private readonly store = inject(SignalStore);

  ranking = input.required<RankingEntry[]>();

  currentUserId = computed(() => this.store.appuser()?.id);

  displayEntries = computed(() => {
    const all = this.ranking();
    const userId = this.currentUserId();
    if (!all || all.length === 0) return [];

    const top5 = all.slice(0, 5);
    const userInTop5 = top5.some((e) => e.userId === userId);

    if (userInTop5 || !userId) {
      return top5.map((e) => ({ ...e, separator: false }));
    }

    const userEntry = all.find((e) => e.userId === userId);
    const top4 = all.slice(0, 4).map((e) => ({ ...e, separator: false }));

    if (userEntry) {
      top4.push({ ...userEntry, separator: true });
    }

    return top4;
  });
}
