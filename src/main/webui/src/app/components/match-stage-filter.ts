import { Component, input, output } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { MatchStage } from '@interfaces/match-stage.enum';

@Component({
  selector: 'match-stage-filter',
  imports: [TranslocoPipe],
  template: `
    <!-- Row 1: All + Group chips -->
    <div class="flex gap-1.5 overflow-x-auto pb-1 no-scrollbar">
      <button
        (click)="stageChange.emit(null)"
        class="flex-1 py-1 rounded-full text-xs font-semibold transition-colors whitespace-nowrap text-center"
        [class.bg-primary-700]="!activeStage()"
        [class.text-gray-200!]="!activeStage()"
        [class.bg-gray-200]="activeStage()"
        [class.text-gray-600]="activeStage()"
        [class.hover:bg-primary-800!]="!activeStage()"
      >
        {{ 'matches.filterAll' | transloco }}
      </button>

      <span class="shrink-0 self-center text-gray-300 dark:text-gray-600">|</span>

      @for (stage of GROUP_STAGES; track stage) {
        <button
          (click)="stageChange.emit(stage)"
          class="shrink-0 w-7 h-7 rounded-full text-xs font-bold transition-colors flex items-center justify-center"
          [class.bg-primary-700!]="activeStage() === stage"
          [class.text-gray-200!]="activeStage() === stage"
          [class.bg-gray-200]="activeStage() !== stage"
          [class.text-gray-600]="activeStage() !== stage"
          [class.hover:bg-primary-800!]="activeStage() === stage"
        >
          {{ stage.split('_')[1] }}
        </button>
      }

      @for (stage of KNOCKOUT_STAGES; track stage) {
        <button
          (click)="stageChange.emit(stage)"
          class="flex-1 py-1 rounded-full text-xs font-semibold transition-colors whitespace-nowrap text-center"
          [class.bg-primary-700]="activeStage() === stage"
          [class.text-gray-200!]="activeStage() === stage"
          [class.bg-gray-200]="activeStage() !== stage"
          [class.text-gray-600]="activeStage() !== stage"
          [class.hover:bg-primary-800!]="activeStage() === stage"
        >
          {{ knockoutLabel(stage) }}
        </button>
      }
    </div>
  `,
  styles: `
    :host {
      display: block;
      position: sticky;
      top: 0;
      z-index: 10;
      padding: 0.5rem;
      border-radius: 0.75rem;
      backdrop-filter: blur(12px);
      -webkit-backdrop-filter: blur(12px);
      background: rgba(255, 255, 255, 0.85);
    }
    :host button {
      border: 0;
      padding: 0;
    }
  `,
})
export class MatchStageFilter {
  activeStage = input<MatchStage | null>(null);
  stageChange = output<MatchStage | null>();

  readonly GROUP_STAGES: MatchStage[] = [
    MatchStage.GROUP_A,
    MatchStage.GROUP_B,
    MatchStage.GROUP_C,
    MatchStage.GROUP_D,
    MatchStage.GROUP_E,
    MatchStage.GROUP_F,
    MatchStage.GROUP_G,
    MatchStage.GROUP_H,
    MatchStage.GROUP_I,
    MatchStage.GROUP_J,
    MatchStage.GROUP_K,
    MatchStage.GROUP_L,
  ];

  readonly KNOCKOUT_STAGES: MatchStage[] = [
    MatchStage.ROUND_OF_32,
    MatchStage.ROUND_OF_16,
    MatchStage.QUARTER_FINALS,
    MatchStage.SEMI_FINALS,
    MatchStage.THIRD_PLACE,
    MatchStage.FINAL,
  ];

  knockoutLabel(stage: MatchStage): string {
    const map: Record<string, string> = {
      ROUND_OF_32: 'R32',
      ROUND_OF_16: 'R16',
      QUARTER_FINALS: 'QF',
      SEMI_FINALS: 'SF',
      THIRD_PLACE: '3rd',
      FINAL: 'Final',
    };
    return map[stage] ?? stage;
  }
}
