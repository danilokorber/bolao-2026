import { Component, computed, inject, input } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'ranking-card-item',
  imports: [TranslocoPipe],
  template: `
    <div
      class="flex items-center gap-3 px-3 sm:px-4 py-2 sm:py-2.5 transition-colors cursor-pointer"
      [class.bg-primary-100]="data().userId === currentUserId()"
      [class.hover:bg-primary-200]="data().userId === currentUserId()"
      [class.dark:bg-primary-900]="data().userId === currentUserId()"
      [class.hover:dark:bg-primary-800]="data().userId === currentUserId()"
      [class.font-bold]="data().userId === currentUserId()"
      [class.bg-gray-50]="data().userId !== currentUserId()"
      [class.hover:bg-gray-200]="data().userId !== currentUserId()"
      [class.dark:bg-gray-800]="data().userId !== currentUserId()"
      [class.hover:dark:bg-gray-600]="data().userId !== currentUserId()"
      (click)="route()"
    >
      <div
        class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold text-white"
        [class.bg-yellow-500]="data().position === 1"
        [class.bg-gray-400]="data().position === 2"
        [class.bg-amber-700]="data().position === 3"
        [class.bg-gray-300]="data().position > 3"
        [class.!text-gray-600]="data().position > 3"
      >
        {{ data().position }}
      </div>
      <span class="flex-1 text-sm sm:text-base truncate">{{ data().userName }}</span>
      @if (data().separator) {
        <span class="text-xs opacity-40">⋯</span>
      }
      <span class="text-sm sm:text-base font-mono tabular-nums">{{ data().totalPoints }}</span>
      <span class="text-xs opacity-50">{{ 'matchSchedule.points' | transloco }}</span>
    </div>
  `,
  styles: ``,
})
export class RankingCardItem {
  private readonly store = inject(SignalStore);
  private router = inject(Router);

  data = input.required<{
    separator: boolean;
    position: number;
    userId: string;
    userName: string;
    count10: number;
    count5: number;
    count3: number;
    count1: number;
    specialPoints: number;
    totalPoints: number;
  }>();
  currentUserId = computed(() => this.store.appuser()?.id);

  route() {
    this.router.navigate(['/bets', this.data().userId]);
  }
}
