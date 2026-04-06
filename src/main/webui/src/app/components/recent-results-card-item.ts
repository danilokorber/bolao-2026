import { Component, inject, input } from '@angular/core';
import { Router } from '@angular/router';
import { Bet } from '@interfaces/index';
import { TranslocoPipe } from '@jsverse/transloco';
import { ScoreService } from '../services/score.service';
import { StageService } from '../services/stage.service';
import { SignalStore } from '../store/signal-store';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';

@Component({
  selector: 'recent-results-card-item',
  imports: [FlagFallbackDirective],
  template: `
    <div
      class="flex items-center gap-2 sm:gap-3 px-3 sm:px-4 py-2 sm:py-2.5 bg-gray-50 dark:bg-gray-800 cursor-pointer hover:bg-gray-200 dark:hover:bg-gray-700 transition-colors"
      (click)="goToMatch(bet().matchId)"
    >
      <span class="shrink-0 text-[10px] sm:text-xs font-medium opacity-50 w-6 sm:w-8 text-center">
        {{ stageService.shortLabel(bet().match?.stage) }}
      </span>

      <div class="flex-1 flex items-center gap-1 sm:gap-2 text-sm sm:text-base min-w-0">
        <div class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-white relative">
          <img
            [imgSrc]="bet().match?.homeTeam?.flagUrl ?? ''"
            [alt]="bet().match?.homeTeam?.fifaCode ?? ''"
            class="absolute inset-0 w-full h-full object-cover"
            style="height: 100%; max-width: none;"
            flag-fallback
          />
        </div>
        <span class="font-semibold text-right flex-1">{{ bet().match?.homeTeam?.fifaCode }}</span>
        <span class="font-bold shrink-0">{{ bet().match?.homeGoals }}</span>
        <span class="opacity-40 shrink-0">:</span>
        <span class="font-bold shrink-0">{{ bet().match?.awayGoals }}</span>
        <span class="font-semibold flex-1">{{ bet().match?.awayTeam?.fifaCode }}</span>
        <div class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-white relative">
          <img
            [imgSrc]="bet().match?.awayTeam?.flagUrl ?? ''"
            [alt]="bet().match?.awayTeam?.fifaCode ?? ''"
            class="absolute inset-0 w-full h-full object-cover"
            style="height: 100%; max-width: none;"
            flag-fallback
          />
        </div>
      </div>

      <div class="shrink-0 text-xs sm:text-sm opacity-50 w-10 sm:w-12 text-center">
        {{ bet().homeGoalsBet }}:{{ bet().awayGoalsBet }}
      </div>

      <div
        class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold text-white"
        [style.background-color]="scoreService.color(bet().pointsEarned ?? 0)"
      >
        {{ bet().pointsEarned ?? 0 }}
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

  bet = input.required<Bet>();

  goToMatch(matchId: string) {
    this.router.navigate(['/matches', matchId]);
  }
}
