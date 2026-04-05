import { Component, effect, inject, input, linkedSignal, model, signal } from '@angular/core';
import { debounce, form, FormField, required } from '@angular/forms/signals';
import { API } from '@api/api';
import { Bet } from '@interfaces/bet.interface';
import { SignalStore } from '../store/signal-store';
import { HttpClient } from '@angular/common/http';
import { Match } from '@interfaces/match.interface';
import { BetRequest } from '@interfaces/bet-request.interface';

@Component({
  selector: 'match-card-bet-form',
  imports: [FormField],
  template: `
    <div>
      <input
        class="w-6 sm:w-8 text-lg sm:text-3xl text-center border-b border-primary-500 outline-0"
        type="number"
        [formField]="form.homeGoalsBet"
      />
    </div>
    <div class="w-4 sm:w-8 text-center">:</div>
    <div>
      <input
        class="w-6 sm:w-8 text-lg sm:text-3xl text-center border-b border-primary-500 outline-0"
        type="number"
        [formField]="form.awayGoalsBet"
      />
    </div>
  `,
  styles: ``,
  host: {
    class: 'flex flex-row justify-center items-center',
  },
})
export class MatchCardBetForm {
  private readonly http = inject(HttpClient);
  private readonly store = inject(SignalStore);

  match = model.required<Match>();

  bet = linkedSignal<BetRequest>(
    () =>
      ({
        userId: this.store.appuser()?.id || '',
        matchId: this.match().id || '',
        homeGoalsBet: this.match().userBet?.homeGoalsBet || null,
        awayGoalsBet: this.match().userBet?.awayGoalsBet || null,
        winnerBetId: this.match().userBet?.winnerBetId,
      }) as BetRequest,
  );

  form = form<BetRequest>(this.bet, (bet) => {
    debounce(bet, 300);
    required(bet.homeGoalsBet);
    required(bet.awayGoalsBet);
  });

  onPredictionChange = effect(() => {
    console.log(
      this.form().dirty(),
      this.form.homeGoalsBet().dirty(),
      this.form.awayGoalsBet().dirty(),
    );

    const homeDirty = this.form.homeGoalsBet().dirty();
    const awayDirty = this.form.awayGoalsBet().dirty();
    if (!homeDirty && !awayDirty) return; // No changes

    const homeValid = this.form.homeGoalsBet().valid();
    const awayValid = this.form.awayGoalsBet().valid();
    if (!homeValid || !awayValid) return; // Invalid values

    this.saveBet();
  });

  private saveBet() {
    const userId = this.store.appuser()?.id;
    const matchId = this.match()?.id;
    if (!userId || !matchId) return;

    const body: BetRequest = {
      userId,
      matchId,
      homeGoalsBet: this.bet().homeGoalsBet,
      awayGoalsBet: this.bet().awayGoalsBet,
    };

    this.http.post<Bet>(API.BETS.SAVE(), body).subscribe({
      next: () => this.showSavedLabel(),
      error: (err) => console.error('Failed to save bet', err),
    });
  }

  showSavedLabel() {
    const savedTip = document.getElementById('savedTip' + this.bet().matchId);
    if (savedTip) {
      savedTip.classList.add('show');
      setTimeout(() => {
        savedTip.classList.remove('show');
      }, 2700);
    }
  }
}
