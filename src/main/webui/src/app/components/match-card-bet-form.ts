import { Component, effect, inject, input, linkedSignal } from '@angular/core';
import { debounce, form, FormField, max, min, required } from '@angular/forms/signals';
import { BetFormData } from '@interfaces/bet-form-data.interface';
import { Bet, MatchV2 } from '@interfaces/index';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'match-card-bet-form',
  imports: [FormField],
  template: `
    @if (match().status === 'SCHEDULED') {
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
    }
  `,
  styles: ``,
  host: {
    class: 'flex flex-row justify-center items-center',
  },
})
export class MatchCardBetForm {
  private readonly store = inject(SignalStore);

  match = input.required<MatchV2>();

  currentBet = linkedSignal<Bet | null>(
    () => this.match().bets?.find((b) => b.userId === this.store.appuser()?.id) ?? null,
  );

  formData = linkedSignal<BetFormData>(() => ({
    homeGoalsBet: this.currentBet()?.homeGoalsBet ?? '',
    awayGoalsBet: this.currentBet()?.awayGoalsBet ?? '',
  }));

  form = form<BetFormData>(this.formData, (bet) => {
    debounce(bet, 300);
    required(bet.homeGoalsBet);
    required(bet.awayGoalsBet);
    min(bet.homeGoalsBet, 0);
    min(bet.awayGoalsBet, 0);
    max(bet.homeGoalsBet, 9);
    max(bet.awayGoalsBet, 9);
  });

  onPredictionChange = effect(() => {
    if (!this.form().valid() || !this.form().dirty()) return;

    if (
      this.form().value().homeGoalsBet != this.currentBet()?.homeGoalsBet ||
      this.form().value().awayGoalsBet != this.currentBet()?.awayGoalsBet
    ) {
      // Only save if values have actually changed
      this.saveBet();
    }
  });

  onGoalInput(current: HTMLInputElement, next?: HTMLInputElement) {
    const val = current.valueAsNumber;
    if (!isNaN(val) && val >= 0 && val <= 9 && next) {
      next.focus();
      next.select();
    }
  }

  private saveBet() {
    const userId = this.store.appuser()?.id!;
    const matchId = this.match()?.id!;
    const homeGoalsBet = Number(this.form.homeGoalsBet().value());
    const awayGoalsBet = Number(this.form.awayGoalsBet().value());

    this.store.placeBet(userId, matchId, homeGoalsBet, awayGoalsBet);

    if (this.currentBet()) {
      this.currentBet.update((bet) => (bet ? { ...bet, homeGoalsBet, awayGoalsBet } : bet));
    } else {
      this.currentBet.set({ userId, matchId, homeGoalsBet, awayGoalsBet });
    }

    this.showSavedLabel();
    this.form().reset(this.formData());
  }

  showSavedLabel() {
    const savedTip = document.getElementById('savedTip' + this.match()?.id);
    if (savedTip) {
      savedTip.classList.add('show');
      setTimeout(() => {
        savedTip.classList.remove('show');
      }, 2700);
    }
  }
}
