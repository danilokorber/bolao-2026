import { Component, computed, inject } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';
import { Card } from './card';
import { MatchCard } from './match-card';
import { MatchCardSkeleton } from './match-card-skeleton';

@Component({
  selector: 'upcoming-matches-card',
  imports: [Card, TranslocoPipe, MatchCard, MatchCardSkeleton],
  template: `
    <card>
      <div card-header>
        {{
          (showingPast()
            ? 'dashboard.upcomingMatches.latestTitle'
            : 'dashboard.upcomingMatches.title'
          ) | transloco
        }}
      </div>
      <div class="p-4 pt-6 flex flex-col gap-6 sm:gap-8">
        @if (!this.store.matchesV2InitiallyLoaded()) {
          <div class="p-4 pt-6 flex flex-col gap-6 sm:gap-8">
            <match-card-skeleton></match-card-skeleton>
            <match-card-skeleton></match-card-skeleton>
          </div>
        } @else {
          @for (match of upcomingMatches(); track match.id) {
            <match-card [match]="match"></match-card>
          } @empty {
            <p class="text-sm opacity-60">{{ 'dashboard.upcomingMatches.noData' | transloco }}</p>
          }
        }
      </div>
    </card>
  `,
  styles: ``,
})
export class UpcomingMatchesCard {
  readonly store = inject(SignalStore);

  showingPast = computed(() => false);
  upcomingMatches = this.store.upcomingMatches36hV2;
}
