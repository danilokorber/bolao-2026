import { Component, inject, input, linkedSignal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { Bet, Match, MatchStatus } from '@interfaces/index';
import { ScoreService } from '@services/score.service';
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
  private readonly scoreService = inject(ScoreService);

  match = input.required<Match>();
  bet = input.required<Bet | undefined>();

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = new Date(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });

  matchInProgress = linkedSignal(() => this.match().status == MatchStatus.LIVE);

  scoreColor = linkedSignal(() =>
    this.scoreService.color(this.bet()?.pointsEarned ?? 0)
  );

  onCardClick() {
    if (this.startIsInThePast()) {
      this.router.navigate(['/matches', this.match().id]);
    }
  }
}
