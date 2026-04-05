import { DatePipe } from '@angular/common';
import { HttpClient } from '@angular/common/http';
import { Component, effect, inject, input, linkedSignal, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, BetRequest, Match, MatchStatus } from '@interfaces/index';
import { SignalStore } from '../store/signal-store';
import { MatchInProgress } from './match-in-progress';
import { MatchCardFlag } from './match-card-flag';
import { MatchCardTeamName } from './match-card-team-name';
import { MatchCardSchedule } from './match-card-schedule';
import { MatchCardBetForm } from './match-card-bet-form';

@Component({
  selector: 'match-card',
  imports: [
    FormsModule,
    TranslocoPipe,
    MatchCardFlag,
    MatchCardTeamName,
    MatchInProgress,
    MatchCardSchedule,
    MatchCardBetForm,
  ],
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
  private readonly router = inject(Router);
  private readonly http = inject(HttpClient);
  private readonly store = inject(SignalStore);

  match = input.required<Match>();
  bet = input.required<Bet | undefined>();

  private saveTimeout: ReturnType<typeof setTimeout> | null = null;
  private initialized = false;

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = new Date(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });

  matchInProgress = linkedSignal(() => this.match().status == MatchStatus.LIVE);

  homePrediction = signal<number | null>(null);
  awayPrediction = signal<number | null>(null);

  scoreColor = linkedSignal(() => {
    const points = this.bet()?.pointsEarned ?? 0;
    const style = getComputedStyle(document.documentElement);
    if (points >= 10) return style.getPropertyValue('--color-score-10').trim();
    if (points >= 5) return style.getPropertyValue('--color-score-5').trim();
    if (points >= 3) return style.getPropertyValue('--color-score-3').trim();
    if (points >= 1) return style.getPropertyValue('--color-score-1').trim();
    return style.getPropertyValue('--color-score-0').trim();
  });

  onCardClick() {
    if (this.startIsInThePast()) {
      this.router.navigate(['/matches', this.match().id]);
    }
  }
}
