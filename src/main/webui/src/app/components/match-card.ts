import { DatePipe } from '@angular/common';
import { Component, effect, input, linkedSignal, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { TranslocoPipe } from '@jsverse/transloco';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, Match, MatchStatus } from '@interfaces/index';
import { MatchInProgress } from './match-in-progress';
import { MatchCardFlag } from './match-card-flag';
import { MatchCardTeamName } from './match-card-team-name';
import { MatchCardSchedule } from './match-card-schedule';

@Component({
  selector: 'match-card',
  imports: [FormsModule, TranslocoPipe, MatchCardFlag, MatchCardTeamName, MatchInProgress, MatchCardSchedule],
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
})
export class MatchCard {
  match = input.required<Match>();
  bet = input.required<Bet | undefined>();

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = new Date(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });

  matchInProgress = linkedSignal(() => this.match().status == MatchStatus.LIVE);

  homePrediction = signal<number | null>(null);
  awayPrediction = signal<number | null>(null);

  onPredictionChange = effect(() => {
    const home = this.homePrediction();
    const away = this.awayPrediction();

    // Here you can handle the prediction change, e.g., send it to a service or update state
    if (home !== null && away !== null) {
      this.showSavedLabel();
    }
  });

  showSavedLabel() {
    const savedTip = document.getElementById('savedTip' + this.match().id);
    if (savedTip) {
      // Fade in
      savedTip.classList.add('show');

      // Fade out after 10 seconds
      setTimeout(() => {
        savedTip.classList.remove('show');
      }, 2700);
    }
  }
}
