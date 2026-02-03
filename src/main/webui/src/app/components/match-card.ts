import { DatePipe } from '@angular/common';
import { Component, effect, input, linkedSignal, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Match } from '@interfaces/index';

@Component({
  selector: 'match-card',
  imports: [FormsModule],
  templateUrl: './match-card.html',
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
  `,
})
export class MatchCard {
  match = input.required<Match>();

  formatMatchDate = linkedSignal(() => {
    const datePipe = new DatePipe('en-US');
    return datePipe.transform(this.match().matchDatetime, 'dd-MMM-yyyy HH:mm')?.toUpperCase() || '';
  });

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = new Date(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });

  matchInProgress = linkedSignal(() => true);

  homePrediction = signal<number | null>(null);
  awayPrediction = signal<number | null>(null);

  onPredictionChange = effect(() => {
    const home = this.homePrediction();
    const away = this.awayPrediction();

    // Here you can handle the prediction change, e.g., send it to a service or update state
    if (home !== null && away !== null) {
      console.log(`Prediction changed: Home - ${home}, Away - ${away}`);
    }
  });
}
