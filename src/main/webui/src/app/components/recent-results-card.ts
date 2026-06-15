import { Component, inject } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';
import { Card } from './card';
import { RecentResultsCardItem } from './recent-results-card-item';
import { RecentResultsCardItemSkeleton } from './recent-results-card-item-skeleton';

@Component({
  selector: 'recent-results-card',
  imports: [Card, TranslocoPipe, RecentResultsCardItem, RecentResultsCardItemSkeleton],
  template: `
    <card>
      <div card-header>{{ 'dashboard.recentResults.title' | transloco }}</div>
      <div class="p-0">
        <div class="flex flex-col">
          @if (!store.matchesV2InitiallyLoaded()) {
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
          } @else {
            @for (match of last5Matches(); track match.id) {
              <recent-results-card-item [match]="match"></recent-results-card-item>
            } @empty {
              <p class="text-sm opacity-60 px-3 py-2">
                {{ 'dashboard.recentResults.noData' | transloco }}
              </p>
            }
          }
        </div>
      </div>
    </card>
  `,
  styles: ``,
})
export class RecentResultsCard {
  protected readonly store = inject(SignalStore);

  last5Matches = this.store.last5MatchesV2;
}
