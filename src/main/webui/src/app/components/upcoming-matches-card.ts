import { Component, computed, input } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { Bet, Match } from '@interfaces/index';
import { MatchCard } from './match-card';

@Component({
  selector: 'upcoming-matches-card',
  imports: [TranslocoPipe, MatchCard],
  template: `
    <div class="flex flex-col border border-gray-200 dark:border-gray-700 rounded-t-xl">
      <div class="border-b border-gray-200 dark:border-gray-700 -mx-4 p-4">
        <h2 class="text-lg sm:text-xl font-bold text-primary-700 dark:text-primary-300">
          {{ (showingPast() ? 'dashboard.upcomingMatches.latestTitle' : 'dashboard.upcomingMatches.title') | transloco }}
        </h2>
      </div>
      <div class="p-3 sm:p-4">
        @if (upcomingMatches().length === 0) {
          <p class="text-sm opacity-60">{{ 'dashboard.upcomingMatches.noData' | transloco }}</p>
        } @else {
          <div class="flex flex-col gap-6 sm:gap-8">
            @for (match of upcomingMatches(); track match.id) {
              <match-card [match]="match" [bet]="betForMatch(match)"></match-card>
            }
          </div>
        }
      </div>
    </div>
  `,
  styles: ``,
})
export class UpcomingMatchesCard {
  matches = input.required<Match[]>();
  bets = input.required<Bet[]>();

  showingPast = computed(() => {
    const matches = this.upcomingMatches();
    if (matches.length === 0) return false;
    const now = new Date();
    const todayStr = this.dateStr(now);
    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = this.dateStr(tomorrow);
    return matches.every((m) => {
      const d = this.dateStr(new Date(m.matchDatetime));
      return d !== todayStr && d !== tomorrowStr && new Date(m.matchDatetime).getTime() < now.getTime();
    });
  });

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

    // Sort all matches by datetime ascending
    const sorted = [...all].sort(
      (a, b) => new Date(a.matchDatetime).getTime() - new Date(b.matchDatetime).getTime(),
    );

    const now = new Date();
    const todayStr = this.dateStr(now);
    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    const tomorrowStr = this.dateStr(tomorrow);

    // Matches today and tomorrow
    const todayTomorrow = sorted.filter((m) => {
      const d = this.dateStr(new Date(m.matchDatetime));
      return d === todayStr || d === tomorrowStr;
    });

    if (todayTomorrow.length > 0) return todayTomorrow;

    // No matches today/tomorrow — find the next future matchday
    const futureMatches = sorted.filter(
      (m) => new Date(m.matchDatetime).getTime() > now.getTime(),
    );

    if (futureMatches.length > 0) {
      const nextDay = this.dateStr(new Date(futureMatches[0].matchDatetime));
      return futureMatches.filter(
        (m) => this.dateStr(new Date(m.matchDatetime)) === nextDay,
      );
    }

    // All matches in the past — show the most recent matchday
    const lastDay = this.dateStr(new Date(sorted[sorted.length - 1].matchDatetime));
    return sorted.filter(
      (m) => this.dateStr(new Date(m.matchDatetime)) === lastDay,
    );
  });

  private dateStr(d: Date): string {
    return d.toISOString().substring(0, 10);
  }
}
