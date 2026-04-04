import { DatePipe } from '@angular/common';
import { Component, input, linkedSignal } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { Bet, Match } from '@interfaces/index';

@Component({
  selector: 'match-card-schedule',
  imports: [TranslocoPipe],
  template: `
    <div
      class="flex text-sm rounded-full px-6 py-1 bg-primary-900 text-gray-50 dark:border-primary-100 dark:bg-primary-100 dark:text-gray-900"
    >
      @if (startIsInThePast()) {
        {{ bet()?.pointsEarned ?? 0 }} {{ bet()?.pointsEarned != 1 ? ('matchSchedule.points' | transloco) : ('matchSchedule.point' | transloco) }}
      } @else {
        {{ formatMatchDate() }}
      }
    </div>
  `,
  styles: ``,
  host: { class: 'absolute -top-3.5 w-full flex justify-center' },
})
export class MatchCardSchedule {
  match = input.required<Match>();
  bet = input.required<Bet | undefined>();

  formatMatchDate = linkedSignal(() => {
    const datePipe = new DatePipe('en-US');
    return datePipe.transform(this.match().matchDatetime, 'dd-MMM-yyyy HH:mm')?.toUpperCase() || '';
  });

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = new Date(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });
}
