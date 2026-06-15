import { DatePipe } from '@angular/common';
import { Component, inject, input, linkedSignal } from '@angular/core';
import { MatchStage, MatchStatus, MatchV2 } from '@interfaces/index';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { ScoreService } from '@services/score.service';
import { utcDate } from '@utils/date-utils';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'match-card-schedule',
  imports: [TranslocoPipe],
  template: `
    <div
      class="flex text-xs sm:text-sm rounded-full px-3 sm:px-6 py-0.5 sm:py-1 text-gray-50"
      [style.background-color]="startIsInThePast() ? scoreColor() : ''"
      [class.bg-primary-900]="!startIsInThePast()"
      [class.dark:border-primary-100]="!startIsInThePast()"
      [class.dark:bg-primary-100]="!startIsInThePast()"
      [class.dark:text-gray-900]="!startIsInThePast()"
    >
      {{ phase() }}&nbsp;&nbsp;•&nbsp;&nbsp;
      @if (isLive()) {
        ⏱️
      } @else if (startIsInThePast()) {
        {{ bet()?.pointsEarned ?? 0 }}
        {{
          bet()?.pointsEarned != 1
            ? ('matchSchedule.points' | transloco)
            : ('matchSchedule.point' | transloco)
        }}
      } @else {
        {{ formatMatchDate() }}
      }
    </div>
  `,
  styles: ``,
  host: { class: 'absolute -top-3 sm:-top-3.5 w-full flex justify-center' },
})
export class MatchCardSchedule {
  private readonly store = inject(SignalStore);
  private readonly scoreService = inject(ScoreService);
  private readonly translocoSerice = inject(TranslocoService);

  match = input.required<MatchV2>();
  bet = linkedSignal(() =>
    this.match().bets?.find((bet) => bet.userId === this.store.appuser()!.id),
  );

  phase = linkedSignal(() => {
    const match = this.match();
    if (match.stage === MatchStage.ROUND_OF_32) {
      return this.translocoSerice.translate('matchDetail.stages.r32');
    } else if (match.stage === MatchStage.ROUND_OF_16) {
      return this.translocoSerice.translate('matchDetail.stages.r16');
    } else if (match.stage === MatchStage.QUARTER_FINALS) {
      return this.translocoSerice.translate('matchDetail.stages.qf');
    } else if (match.stage === MatchStage.SEMI_FINALS) {
      return this.translocoSerice.translate('matchDetail.stages.sf');
    } else if (match.stage === MatchStage.THIRD_PLACE) {
      return this.translocoSerice.translate('matchDetail.stages.third');
    } else if (match.stage === MatchStage.FINAL) {
      return this.translocoSerice.translate('matchDetail.stages.final');
    }
    return (
      this.translocoSerice.translate('matchDetail.stages.group') + ' ' + match.stage.split('_')[1]
    );
  });

  formatMatchDate = linkedSignal(() => {
    const datePipe = new DatePipe('en-US');
    return (
      datePipe.transform(utcDate(this.match().matchDatetime), 'dd-MMM-yyyy HH:mm')?.toUpperCase() ||
      ''
    );
  });

  isLive = linkedSignal(() => this.match().status == MatchStatus.LIVE);

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = utcDate(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });

  scoreColor = linkedSignal(() => this.scoreService.color(this.bet()?.pointsEarned ?? 0));
}
