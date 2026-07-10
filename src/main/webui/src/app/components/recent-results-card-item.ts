import { Component, computed, inject, input } from '@angular/core';
import { Router } from '@angular/router';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { MatchV2 } from '@interfaces/index';
import { ScoreService } from '../services/score.service';
import { StageService } from '../services/stage.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'recent-results-card-item',
  imports: [FlagFallbackDirective],
  template: `
    <div
      class="flex items-center gap-2 sm:gap-3 px-3 sm:px-4 py-2 sm:py-2.5 bg-gray-50 dark:bg-gray-800 cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
      (click)="goToMatch()"
    >
      <span class="shrink-0 text-[10px] sm:text-xs font-medium opacity-50 w-6 sm:w-8 text-center">
        {{ stageService.shortLabel(match().stage) }}
      </span>

      <div class="flex-1 flex items-center gap-1 sm:gap-2 text-sm sm:text-base min-w-0">
        <div class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-white relative">
          <img
            [imgSrc]="match().homeTeam?.flagUrl ?? ''"
            [alt]="match().homeTeam?.fifaCode ?? ''"
            class="absolute inset-0 w-full h-full object-cover"
            style="height: 100%; max-width: none;"
            flag-fallback
          />
        </div>
        <span class="font-semibold text-right flex-1">{{ match().homeTeam?.fifaCode }}</span>
        <span class="font-bold shrink-0">{{ match().homeGoals }}</span>
        <span class="opacity-40 shrink-0">:</span>
        <span class="font-bold shrink-0">{{ match().awayGoals }}</span>
        <span class="font-semibold flex-1">{{ match().awayTeam?.fifaCode }}</span>
        <div class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-white relative">
          <img
            [imgSrc]="match().awayTeam?.flagUrl ?? ''"
            [alt]="match().awayTeam?.fifaCode ?? ''"
            class="absolute inset-0 w-full h-full object-cover"
            style="height: 100%; max-width: none;"
            flag-fallback
          />
        </div>
      </div>

      <div class="shrink-0 text-xs sm:text-sm opacity-50 w-10 sm:w-12 text-center">
        {{ bet()?.homeGoalsBet }}:{{ bet()?.awayGoalsBet }}
      </div>

      <div
        class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold text-white"
        [style.background-color]="scoreService.color(bet()?.pointsEarned ?? 0, bet()?.scoreTier)"
      >
        {{ bet()?.pointsEarned ?? 0 }}
      </div>
    </div>
  `,
  styles: ``,
})
export class RecentResultsCardItem {
  private readonly store = inject(SignalStore);
  private readonly router = inject(Router);
  protected readonly scoreService = inject(ScoreService);
  protected readonly stageService = inject(StageService);

  match = input.required<MatchV2>();
  bet = computed(() => {
    const bets = this.match().bets;
    return bets?.find((b) => b.userId === this.store.appuser()?.id) ?? undefined;
  });

  goToMatch() {
    this.router.navigate(['/matches', this.match().id]);
  }
}
