import { Component } from '@angular/core';

@Component({
  selector: 'ranking-item-skeleton',
  template: `
    <div
      class="flex items-center gap-3 px-3 sm:px-4 py-2 sm:py-2.5 transition-colors animate-pulse"
    >
      <div
        class="shrink-0 w-7 h-7 sm:w-8 sm:h-8 rounded-full bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div class="flex-1">
        <div class="w-2/3 text-xs sm:text-xs rounded bg-primary-100/80 dark:bg-primary-900/60">
          &nbsp;
        </div>
      </div>
      <div
        class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div
        class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div
        class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div
        class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div
        class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div
        class="shrink-0 w-5 h-5 sm:w-6 sm:h-6 rounded bg-primary-100/80 dark:bg-primary-900/60"
      ></div>
      <div class="w-8 text-xs bg-primary-100/80 dark:bg-primary-900/60">&nbsp;</div>
    </div>
  `,
  styles: ``,
})
export class RankingItemSkeleton {}
