import { Card } from './card';
import { Component, computed, input } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { Bet, Match } from '@interfaces/index';
import { utcDate } from '@utils/date-utils';
import { MatchCard } from './match-card';

@Component({
  selector: 'upcoming-matches-card',
  imports: [Card, TranslocoPipe, MatchCard],
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
        @for (match of upcomingMatches(); track match.id) {
          <match-card [match]="match" [bet]="betForMatch(match)"></match-card>
        } @empty {
          <p class="text-sm opacity-60">{{ 'dashboard.upcomingMatches.noData' | transloco }}</p>
        }
      </div>
    </card>
  `,
  styles: ``,
})
export class UpcomingMatchesCard {
  matches = input.required<Match[]>();
  bets = input.required<Bet[]>();

  showingPast = computed(() => false);

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

  upcomingMatches = computed(() => {
    const all = this.matches();
    if (!all || all.length === 0) return [];

    const now = Date.now();

    // Only future matches, sorted ascending
    const future = [...all]
      .filter(m => utcDate(m.matchDatetime).getTime() > now)
      .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());

    // Show matches in the next 36 hours OR the next 4, whichever is more
    const cutoff = now + 36 * 60 * 60 * 1000;
    const within36h = future.filter(m => utcDate(m.matchDatetime).getTime() <= cutoff);
    return within36h.length >= 4 ? within36h : future.slice(0, 4);
  });

  private dateStr(d: Date): string {
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
  }
}
