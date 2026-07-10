import { Component, computed, inject, input, linkedSignal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { MatchStage, MatchStatus, MatchV2 } from '@interfaces/index';
import { TranslocoPipe } from '@jsverse/transloco';
import { ScoreService } from '@services/score.service';
import { utcDate } from '@utils/date-utils';
import { SignalStore } from '../store/signal-store';
import { MatchCardBetForm } from './match-card-bet-form';
import { MatchCardFlag } from './match-card-flag';
import { MatchCardSchedule } from './match-card-schedule';
import { MatchCardTeamName } from './match-card-team-name';
import { MatchFireworks } from './match-fireworks';
import { MatchInProgress } from './match-in-progress';
import { MatchOdds } from './match-odds';

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
    MatchOdds,
    MatchFireworks,
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
  private readonly store = inject(SignalStore);

  MatchStatus = MatchStatus;

  match = input.required<MatchV2>();
  bet = linkedSignal(() =>
    this.match().bets?.find((bet) => bet.userId === this.store.appuser()!.id),
  );

  isKnockOutMatch = computed(() => {
    const stage = this.match().stage;
    return (
      stage === MatchStage.ROUND_OF_32 ||
      stage === MatchStage.ROUND_OF_16 ||
      stage === MatchStage.QUARTER_FINALS ||
      stage === MatchStage.SEMI_FINALS ||
      stage === MatchStage.THIRD_PLACE ||
      stage === MatchStage.FINAL
    );
  });

  isZebra = computed(() => {
    const bets = this.match().bets ?? [];
    if (bets.length === 0) return false; // No bets, default to non-zebra

    const betsWrong = bets.filter((bet) => bet.pointsEarned === -6).length;
    return betsWrong / bets.length >= 0.75; // Zebra if 75% or more bets are wrong
  });

  startIsInThePast = linkedSignal(() => {
    const NOW = new Date().getTime();
    const SCHEDULE = utcDate(this.match().matchDatetime).getTime();
    return NOW > SCHEDULE;
  });

  matchInProgress = linkedSignal(() => this.match().status == MatchStatus.LIVE);

  scoreColor = linkedSignal(() => this.scoreService.color(this.bet()?.pointsEarned ?? 0, this.bet()?.scoreTier));

  onCardClick() {
    if (this.startIsInThePast()) {
      this.router.navigate(['/matches', this.match().id]);
    }
  }
}
