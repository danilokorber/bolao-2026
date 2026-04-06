import { Component, computed, inject, input } from '@angular/core';
import { Router, RouterLink } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { SignalStore } from '../store/signal-store';
import { Card } from './card';
import { RankingCardItem } from './ranking-card-item';

@Component({
  selector: 'ranking-card',
  imports: [Card, RankingCardItem, TranslocoPipe],
  template: `
    <card>
      <div card-header (click)="route()" class="cursor-pointer">
        {{ 'dashboard.ranking.title' | transloco }}
      </div>
      <div class="p-0 flex flex-col">
        @for (entry of displayEntries(); track entry.userId) {
          <ranking-card-item [data]="entry"></ranking-card-item>
        } @empty {
          <p class="text-sm opacity-60 px-3 py-2">
            {{ 'dashboard.ranking.noData' | transloco }}
          </p>
        }
      </div>
    </card>
  `,
  styles: ``,
})
export class RankingCard {
  private readonly store = inject(SignalStore);
  private router = inject(Router);

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

  route() {
    this.router.navigate(['/ranking']);
  }
}
