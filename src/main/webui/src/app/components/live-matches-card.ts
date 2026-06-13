import { Component, computed, input } from '@angular/core';
import { Bet, Match, MatchStatus } from '@interfaces/index';
import { TranslocoPipe } from '@jsverse/transloco';
import { utcDate } from '@utils/date-utils';
import { Card } from './card';
import { MatchCard } from './match-card';

@Component({
  selector: 'live-matches-card',
  imports: [Card, TranslocoPipe, MatchCard],
  template: `
    <card>
      <div card-header>
        {{
          (showingPast() ? 'dashboard.liveMatches.latestTitle' : 'dashboard.liveMatches.title')
            | transloco
        }}
      </div>
      <div class="p-4 pt-6 flex flex-col gap-6 sm:gap-8">
        @for (match of liveMatches(); track match.id) {
          <match-card [match]="match"></match-card>
        } @empty {
          <p class="text-sm opacity-60">{{ 'dashboard.liveMatches.noData' | transloco }}</p>
        }
      </div>
    </card>
  `,
  styles: ``,
})
export class LiveMatchesCard {
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

  liveMatches = computed(() => {
    const all = this.matches();
    if (!all || all.length === 0) return [];

    const now = Date.now();

    // Only live matches, sorted ascending
    const live = [...all]
      .filter((m) => m.status == MatchStatus.LIVE)
      .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());

    return live;
  });
}
