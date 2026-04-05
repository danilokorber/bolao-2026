import { Component, computed, inject, input } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, MatchStatus } from '@interfaces/index';
import { ScoreService } from '@services/score.service';
import { StageService } from '@services/stage.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'recent-results-card',
  imports: [TranslocoPipe, FlagFallbackDirective],
  template: `
    <div class="flex flex-col border border-gray-200 dark:border-gray-700 rounded-t-xl">
      <div class="border-b border-gray-200 dark:border-gray-700 -mx-4 p-4">
        <h2 class="text-lg sm:text-xl font-bold text-primary-700 dark:text-primary-300">
          {{ 'dashboard.recentResults.title' | transloco }}
        </h2>
      </div>
      <div class="p-0">
        @if (recentBets().length === 0) {
          <p class="text-sm opacity-60 px-3 py-2">
            {{ 'dashboard.recentResults.noData' | transloco }}
          </p>
        } @else {
          <div class="flex flex-col">
            @for (bet of recentBets(); track bet.id) {
              <div
                class="flex items-center gap-2 sm:gap-3 px-3 sm:px-4 py-2 sm:py-2.5 bg-gray-50 dark:bg-gray-800 cursor-pointer hover:bg-gray-100 dark:hover:bg-gray-700 transition-colors"
                (click)="goToMatch(bet.matchId)"
              >
                <!-- Stage label -->
                <span
                  class="shrink-0 text-[10px] sm:text-xs font-medium opacity-50 w-6 sm:w-8 text-center"
                >
                  {{ stageService.shortLabel(bet.match?.stage) }}
                </span>

                <!-- Match result with flags -->
                <div class="flex-1 flex items-center gap-1 sm:gap-2 text-sm sm:text-base min-w-0">
                  <div
                    class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-white relative"
                  >
                    <img
                      [imgSrc]="bet.match?.homeTeam?.flagUrl ?? ''"
                      [alt]="bet.match?.homeTeam?.fifaCode ?? ''"
                      class="absolute inset-0 w-full h-full object-cover"
                      style="height: 100%; max-width: none;"
                      flag-fallback
                    />
                  </div>
                  <span class="font-semibold text-right flex-1">{{
                    bet.match?.homeTeam?.fifaCode
                  }}</span>
                  <span class="font-bold shrink-0">{{ bet.match?.homeGoals }}</span>
                  <span class="opacity-40 shrink-0">:</span>
                  <span class="font-bold shrink-0">{{ bet.match?.awayGoals }}</span>
                  <span class="font-semibold flex-1">{{ bet.match?.awayTeam?.fifaCode }}</span>
                  <div
                    class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-white relative"
                  >
                    <img
                      [imgSrc]="bet.match?.awayTeam?.flagUrl ?? ''"
                      [alt]="bet.match?.awayTeam?.fifaCode ?? ''"
                      class="absolute inset-0 w-full h-full object-cover"
                      style="height: 100%; max-width: none;"
                      flag-fallback
                    />
                  </div>
                </div>

                <!-- User bet -->
                <div class="shrink-0 text-xs sm:text-sm opacity-50 w-10 sm:w-12 text-center">
                  {{ bet.homeGoalsBet }}:{{ bet.awayGoalsBet }}
                </div>

                <!-- Points badge -->
                <div
                  class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold text-white"
                  [style.background-color]="scoreService.color(bet.pointsEarned ?? 0)"
                >
                  {{ bet.pointsEarned ?? 0 }}
                </div>
              </div>
            }
          </div>
        }
      </div>
    </div>
  `,
  styles: ``,
})
export class RecentResultsCard {
  private readonly store = inject(SignalStore);
  private readonly router = inject(Router);
  protected readonly scoreService = inject(ScoreService);
  protected readonly stageService = inject(StageService);

  bets = input.required<Bet[]>();

  currentUserId = computed(() => this.store.appuser()?.id);

  recentBets = computed(() => {
    const userId = this.currentUserId();
    const now = Date.now();

    const finished = this.bets().filter(
      (b) =>
        b.match && (b.match.status === MatchStatus.FINISHED || b.match.status === MatchStatus.LIVE),
    );

    // Group bets by match, prefer current user's bet
    const byMatch = new Map<string, Bet>();
    for (const b of finished) {
      const mid = b.matchId;
      if (!byMatch.has(mid) || b.userId === userId) {
        byMatch.set(mid, b);
      }
    }

    return [...byMatch.values()]
      .sort((a, b) => {
        const distA = Math.abs(new Date(a.match!.matchDatetime).getTime() - now);
        const distB = Math.abs(new Date(b.match!.matchDatetime).getTime() - now);
        return distA - distB;
      })
      .slice(0, 5);
  });

  goToMatch(matchId: string) {
    this.router.navigate(['/matches', matchId]);
  }
}
