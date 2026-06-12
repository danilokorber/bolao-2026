import { Component } from '@angular/core';

@Component({
  selector: 'recent-results-card-item-skeleton',
  template: `
    <div
      class="flex items-center gap-2 sm:gap-3 px-3 sm:px-4 py-2 sm:py-2.5 transition-colors animate-pulse"
    >
      <div
        id="group"
        class="shrink-0 w-4 sm:w-6 h-4 rounded bg-primary-100/80 dark:bg-primary-900/60"
      >
        &nbsp;
      </div>

      <div class="flex-1 flex items-center gap-1 sm:gap-2 text-sm sm:text-base min-w-0">
        <div
          id="homeFlag"
          class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full overflow-hidden bg-primary-100/80 dark:bg-primary-900/60 relative"
        ></div>

        <div id="homeTeam" class="flex-1 flex flex-row justify-end text-xs">
          <div class="w-full block rounded bg-primary-100/80 dark:bg-primary-900/60 ">&nbsp;</div>
        </div>

        <div
          id="homeScore"
          class="w-8 h-8 rounded-full flex items-center justify-center bg-primary-100/80 dark:bg-primary-900/60"
        ></div>
        <div class="flex items-center justify-center text-primary-700 dark:text-primary-300">:</div>
        <div
          id="awayScore"
          class="w-8 h-8 rounded-full flex items-center justify-center bg-primary-100/80 dark:bg-primary-900/60"
        ></div>

        <div id="awayTeam" class="flex-1 flex flex-row justify-start text-xs">
          <div class="w-full block rounded bg-primary-100/80 dark:bg-primary-900/60 ">&nbsp;</div>
        </div>

        <div
          id="awayFlag"
          class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded-full bg-primary-100/80 dark:bg-primary-900/60 relative"
        ></div>
      </div>

      <div
        class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full flex items-center justify-center text-xs sm:text-sm font-bold bg-primary-100/80 dark:bg-primary-900/60"
      >
        &nbsp;
      </div>
    </div>
  `,
  styles: ``,
})
export class RecentResultsCardItemSkeleton {}
