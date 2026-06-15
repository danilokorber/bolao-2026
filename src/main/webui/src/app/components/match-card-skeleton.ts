import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'match-card-skeleton',
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div
      aria-hidden="true"
      class="relative w-full flex flex-row h-16 sm:h-24 rounded-full border-t border-l border-r border-primary-200 bg-white dark:bg-green-950 animate-pulse shadow-xl"
    >
      <!-- Schedule -->
      <div class="absolute -top-3 sm:-top-3.5 w-full flex justify-center">
        <div
          class="flex w-1/5 text-xs sm:text-sm rounded-full px-3 sm:px-6 py-0.5 sm:py-1 bg-primary-100/80 dark:bg-primary-900/60"
        >
          &nbsp;
        </div>
      </div>

      <!-- flag left -->
      <div
        class=" h-16 w-16 sm:h-24 sm:w-24 shrink-0 rounded-full overflow-hidden shadow-2xl bg-primary-100/80 dark:bg-primary-900/60 relative"
      ></div>

      <!-- middle -->
      <div class="flex-1 w-full flex flex-row gap-3 sm:gap-4 justify-center items-center">
        <div class="flex-1 flex flex-row justify-end text-xs">
          <div class="w-2/3 block rounded bg-primary-100/80 dark:bg-primary-900/60 ">&nbsp;</div>
        </div>
        <div
          class="w-8 h-8 rounded-full flex items-center justify-center bg-primary-100/80 dark:bg-primary-900/60"
        ></div>
        <div class="flex items-center justify-center text-primary-700 dark:text-primary-300">:</div>
        <div
          class="w-8 h-8 rounded-full flex items-center justify-center bg-primary-100/80 dark:bg-primary-900/60"
        ></div>
        <div class="flex-1 flex flex-row justify-start text-xs">
          <div class="w-2/3 block rounded bg-primary-100/80 dark:bg-primary-900/60 ">&nbsp;</div>
        </div>
      </div>

      <!-- flag right -->
      <div
        class=" h-16 w-16 sm:h-24 sm:w-24 shrink-0 rounded-full overflow-hidden shadow-2xl bg-primary-100/80 dark:bg-primary-900/60 relative"
      ></div>

      <!-- <div class="w-8 sm:w-10 h-full flex items-center justify-center">
        <div
          class="w-6 h-6 sm:w-8 sm:h-8 rounded-full bg-primary-100/90 dark:bg-primary-900/60"
        ></div>
      </div>

      <div class="flex-1 w-full flex flex-row gap-2 justify-center items-center px-2 sm:px-4">
        <div class="h-3 sm:h-4 w-16 sm:w-24 rounded bg-primary-100/90 dark:bg-primary-900/60"></div>
        <div class="h-6 sm:h-8 w-14 sm:w-20 rounded bg-primary-100/90 dark:bg-primary-900/60"></div>
        <div class="h-3 sm:h-4 w-16 sm:w-24 rounded bg-primary-100/90 dark:bg-primary-900/60"></div>
      </div>

      <div class="w-8 sm:w-10 h-full flex items-center justify-center">
        <div
          class="w-6 h-6 sm:w-8 sm:h-8 rounded-full bg-primary-100/90 dark:bg-primary-900/60"
        ></div>
      </div> -->
    </div>
  `,
  styles: `
    /* Chrome, Safari, Edge, Opera */
    input[type='number']::-webkit-outer-spin-button,
    input[type='number']::-webkit-inner-spin-button {
      -webkit-appearance: none;
      margin: 0;
    }

    /* Firefox */
    input[type='number'] {
      -moz-appearance: textfield;
      appearance: textfield;
    }

    .saved-tip {
      opacity: 0;
      visibility: hidden;
      transition:
        opacity 0.3s ease-in-out,
        visibility 0.3s ease-in-out;
    }

    .saved-tip.show {
      opacity: 1;
      visibility: visible;
    }
  `,
  imports: [],
})
export class MatchCardSkeleton {}
