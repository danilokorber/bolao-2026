import { Component, computed, inject } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';
import { Card } from './card';
import { RankingCardItem } from './ranking-card-item';
import { RankingCardItemSkeleton } from './ranking-card-item-skeleton';

@Component({
  selector: 'ranking-card',
  imports: [Card, RankingCardItem, TranslocoPipe, RankingCardItemSkeleton],
  template: `
    <card>
      <div card-header (click)="route()" class="cursor-pointer">
        {{ 'dashboard.ranking.title' | transloco }}
      </div>
      <div class="p-0 flex flex-col">
        @if (!store.rankingInitiallyLoaded()) {
          <ranking-card-item-skeleton></ranking-card-item-skeleton>
          <ranking-card-item-skeleton></ranking-card-item-skeleton>
          <ranking-card-item-skeleton></ranking-card-item-skeleton>
          <ranking-card-item-skeleton></ranking-card-item-skeleton>
          <ranking-card-item-skeleton></ranking-card-item-skeleton>
        } @else {
          @for (entry of displayEntries(); track entry.userId) {
            <ranking-card-item [data]="entry"></ranking-card-item>
          } @empty {
            <p class="text-sm opacity-60 px-3 py-2">
              {{ 'dashboard.ranking.noData' | transloco }}
            </p>
          }
        }
      </div>
    </card>
  `,
  styles: ``,
})
export class RankingCard {
  readonly store = inject(SignalStore);
  private router = inject(Router);

  ranking = this.store.rankingSorted;

  currentUserId = computed(() => this.store.appuser()?.id);

  displayEntries = computed(() => {
    if (!this.ranking() || this.ranking().length === 0) return [];
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

  route() {
    this.router.navigate(['/ranking']);
  }
}
