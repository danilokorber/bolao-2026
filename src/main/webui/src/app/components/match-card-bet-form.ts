import { HttpClient } from '@angular/common/http';
import { Component, effect, inject, linkedSignal, model, output } from '@angular/core';
import { debounce, form, FormField, min, required } from '@angular/forms/signals';
import { API } from '@api/api';
import { BetFormData } from '@interfaces/bet-form-data.interface';
import { BetRequest } from '@interfaces/bet-request.interface';
import { Bet } from '@interfaces/bet.interface';
import { Match } from '@interfaces/match.interface';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'match-card-bet-form',
  imports: [FormField],
  template: `
    <div>
      <input
        #homeInput
        class="w-6 sm:w-8 text-lg sm:text-3xl text-center border-b border-primary-500 outline-0"
        type="number"
        [formField]="form.homeGoalsBet"
        (focus)="homeInput.select()"
        (input)="onGoalInput(homeInput, awayInput)"
      />
    </div>
    <div class="w-4 sm:w-8 text-center">:</div>
    <div>
      <input
        #awayInput
        class="w-6 sm:w-8 text-lg sm:text-3xl text-center border-b border-primary-500 outline-0"
        type="number"
        [formField]="form.awayGoalsBet"
        (focus)="awayInput.select()"
        (input)="onGoalInput(awayInput)"
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
  matchStarted = output<void>();

  data = linkedSignal<BetFormData>(
    () => this.store.betForMatch(this.match().id!) ?? ({} as BetFormData),
  );

  form = form<BetFormData>(this.data, (bet) => {
    debounce(bet, 300);
    required(bet.homeGoalsBet!);
    required(bet.awayGoalsBet!);
    min(bet.homeGoalsBet!, 0);
    min(bet.awayGoalsBet!, 0);
  });

  onPredictionChange = effect(() => {
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
      homeGoalsBet: this.data().homeGoalsBet,
      awayGoalsBet: this.data().awayGoalsBet,
    };

    this.http.post<Bet>(API.BETS.SAVE(), body).subscribe({
      next: (updatedBet) => {
        this.showSavedLabel();
      },
      error: (err) => {
        if (err.status === 400) {
          this.matchStarted.emit();
        }
        console.error('Failed to save bet', err);
      },
    });
  }

  onGoalInput(current: HTMLInputElement, next?: HTMLInputElement) {
    const val = current.valueAsNumber;
    if (!isNaN(val) && val >= 0 && val <= 9 && next) {
      next.focus();
      next.select();
    }
  }

  showSavedLabel() {
    const savedTip = document.getElementById('savedTip' + this.data().matchId);
    if (savedTip) {
      savedTip.classList.add('show');
      setTimeout(() => {
        savedTip.classList.remove('show');
      }, 2700);
    }
  }
}
