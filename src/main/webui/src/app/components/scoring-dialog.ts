import { Component, ElementRef, viewChild } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';

@Component({
  selector: 'scoring-dialog',
  imports: [TranslocoPipe],
  template: `
    <dialog
      #dialog
      class="rounded-2xl p-6 max-w-lg w-full backdrop:bg-black/50 shadow-xl dark:text-white dark:bg-primary-900"
      (click)="onBackdropClick($event)"
    >
      <div class="flex flex-col gap-4">
        <div class="flex items-center justify-between">
          <h2 class="text-2xl font-bold text-primary-700 dark:text-primary-500">
            {{ 'account.scoring.title' | transloco }}
          </h2>
          <button class="px-3! py-1! border-0! text-lg" (click)="close()">✕</button>
        </div>
        <p class="text-sm opacity-75 dark:opacity-60">
          {{ 'account.scoring.subtitle' | transloco }}
        </p>

        <!-- Match bets -->
        <div class="flex flex-col gap-2">
          <h3 class="text-lg font-semibold">
            ⚽ {{ 'account.scoring.matchBets.title' | transloco }}
          </h3>
          <p class="text-xs opacity-60 dark:opacity-50 pl-2">
            {{ 'account.scoring.matchBets.note90min' | transloco }}
          </p>
          <div class="flex flex-col gap-1 pl-2">
            <div class="flex items-center gap-2">
              <span class="score-badge score-10">20</span>
              <span>{{ 'account.scoring.matchBets.exact' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-5">10</span>
              <span>{{ 'account.scoring.matchBets.goalDiff' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-3">6</span>
              <span>{{ 'account.scoring.matchBets.winner' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-1">2</span>
              <span>{{ 'account.scoring.matchBets.inverted' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-neg">-6</span>
              <span>{{ 'account.scoring.matchBets.wrong' | transloco }}</span>
            </div>
          </div>
        </div>

        <!-- Stage multipliers -->
        <div class="flex flex-col gap-2">
          <h3 class="text-lg font-semibold">
            📈 {{ 'account.scoring.multipliers.title' | transloco }}
          </h3>
          <p class="text-xs opacity-60 dark:opacity-50 pl-2">
            {{ 'account.scoring.multipliers.subtitle' | transloco }}
          </p>
          <div class="grid grid-cols-2 gap-1 pl-2 text-sm">
            <span class="opacity-75">{{ 'account.scoring.multipliers.group' | transloco }}</span>
            <span class="font-semibold">×1</span>
            <span class="opacity-75">{{ 'account.scoring.multipliers.r32' | transloco }}</span>
            <span class="font-semibold">×1</span>
            <span class="opacity-75">{{ 'account.scoring.multipliers.r16' | transloco }}</span>
            <span class="font-semibold">×1.5</span>
            <span class="opacity-75">{{ 'account.scoring.multipliers.qf' | transloco }}</span>
            <span class="font-semibold">×2</span>
            <span class="opacity-75">{{ 'account.scoring.multipliers.sf' | transloco }}</span>
            <span class="font-semibold">×3</span>
            <span class="opacity-75">{{ 'account.scoring.multipliers.final' | transloco }}</span>
            <span class="font-semibold">×3</span>
          </div>
        </div>

        <!-- Group winner bets -->
        <div class="flex flex-col gap-2">
          <h3 class="text-lg font-semibold">
            🏅 {{ 'account.scoring.groupBets.title' | transloco }}
          </h3>
          <div class="flex flex-col gap-1 pl-2">
            <div class="flex items-center gap-2">
              <span class="score-badge score-10">5</span>
              <span>{{ 'account.scoring.groupBets.first' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-5">3</span>
              <span>{{ 'account.scoring.groupBets.second' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-1">+2</span>
              <span>{{ 'account.scoring.groupBets.both' | transloco }}</span>
            </div>
          </div>
        </div>

        <!-- Champion bets -->
        <div class="flex flex-col gap-2">
          <h3 class="text-lg font-semibold">
            🏆 {{ 'account.scoring.championBets.title' | transloco }}
          </h3>
          <div class="flex flex-col gap-1 pl-2">
            <div class="flex items-center gap-2">
              <span class="score-badge score-10">20</span>
              <span>{{ 'account.scoring.championBets.champion' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-5">10</span>
              <span>{{ 'account.scoring.championBets.runnerUp' | transloco }}</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="score-badge score-3">5</span>
              <span>{{ 'account.scoring.championBets.semifinalist' | transloco }}</span>
            </div>
          </div>
        </div>

        <!-- Time limits -->
        <div class="flex flex-col gap-2">
          <h3 class="text-lg font-semibold">
            ⏰ {{ 'account.scoring.timeLimit.title' | transloco }}
          </h3>
          <ul class="flex flex-col gap-1 pl-2 text-sm list-disc list-inside">
            <li>{{ 'account.scoring.timeLimit.match' | transloco }}</li>
            <li>{{ 'account.scoring.timeLimit.group' | transloco }}</li>
            <li>{{ 'account.scoring.timeLimit.champion' | transloco }}</li>
          </ul>
        </div>

        <button class="mt-2" (click)="close()">
          {{ 'account.scoring.close' | transloco }}
        </button>
      </div>
    </dialog>
  `,
})
export class ScoringDialog {
  private readonly dialogEl = viewChild.required<ElementRef<HTMLDialogElement>>('dialog');

  open() {
    this.dialogEl().nativeElement.showModal();
  }

  close() {
    this.dialogEl().nativeElement.close();
  }

  onBackdropClick(event: MouseEvent) {
    if (event.target === this.dialogEl().nativeElement) {
      this.close();
    }
  }
}
