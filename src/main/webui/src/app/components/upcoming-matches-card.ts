import { Component, computed, inject } from '@angular/core';
import { Bet, Match } from '@interfaces/index';
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
        @if (!matchesLoaded()) {
          <div class="p-4 pt-6 flex flex-col gap-6 sm:gap-8">
            <match-card-skeleton></match-card-skeleton>
            <match-card-skeleton></match-card-skeleton>
          </div>
        } @else if (matchesLoaded()) {
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
  // userId = input<string | undefined>(undefined);
  // bets = input.required<Bet[]>();

  showingPast = computed(() => false);

  matchesLoaded = this.store.matchesInitiallyLoaded;
  matches = this.store.allMatches;
  upcomingMatches = this.store.upcomingMatches36h;

  bets = this.store.allBets;

  private betsByMatch = computed(() => {
    const map = new Map<string, Bet>();
    for (const b of this.bets()) {
      if (b.matchId) map.set(b.matchId, b);
    }
    return map;
  });

  betForMatch(match: Match): Bet | undefined {
    return this.betsByMatch().get(match.id ?? '');
  }

  // upcomingMatches = computed(() => {
  //   if (!this.matches.hasValue()) return [];
  //   const all = this.matches.value().content;
  //   if (!all || all.length === 0) return [];

  //   const now = Date.now();

  //   // Only future matches, sorted ascending
  //   const future = [...all]
  //     .filter((m) => utcDate(m.matchDatetime).getTime() > now)
  //     .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());

  //   // Show matches in the next 36 hours OR the next 4, whichever is more
  //   const cutoff = now + 36 * 60 * 60 * 1000;
  //   const within36h = future.filter((m) => utcDate(m.matchDatetime).getTime() <= cutoff);
  //   return within36h.length >= 4 ? within36h : future.slice(0, 4);
  // });

  private dateStr(d: Date): string {
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
  }
}
