import { Component, inject, input } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { TeamSelect } from '@components/team-select';
import { SaveIndicator } from '@components/save-indicator';
import { GroupWinnerBet, GroupWinnerBetRequest, Team } from '@interfaces/index';
import { BetSaveService, SaveState } from '@services/bet-save.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'group-bet-row',
  imports: [TranslocoPipe, TeamSelect, SaveIndicator],
  template: `
    <div class="flex items-center gap-2 sm:gap-4 py-1 border-b border-gray-100 last:border-b-0">
      <!-- Group badge -->
      <div
        class="shrink-0 w-7 h-7 rounded-full bg-primary-700 text-white flex items-center justify-center text-xs font-bold"
      >
        {{ label() }}
      </div>

      <!-- Selects -->
      <div class="flex-1 flex flex-col sm:flex-row gap-2">
        <div class="flex-1">
          <div class="flex items-center gap-1">
            <span class="text-xl shrink-0">🥇</span>
            <team-select
              class="flex-1"
              [teams]="availableForFirst()"
              [value]="firstPlaceTeamId"
              [placeholder]="'groupWinnerBets.selectTeam' | transloco"
              [disabled]="locked()"
              (selected)="onFirstChange($event)"
              [filterable]="false"
            ></team-select>
          </div>
        </div>
        <div class="flex-1">
          <div class="flex items-center gap-1">
            <span class="text-xl shrink-0">🥈</span>
            <team-select
              class="flex-1"
              [teams]="availableForSecond()"
              [value]="secondPlaceTeamId"
              [placeholder]="'groupWinnerBets.selectTeam' | transloco"
              [disabled]="locked()"
              (selected)="onSecondChange($event)"
              [filterable]="false"
            ></team-select>
          </div>
        </div>
      </div>

      <!-- Status -->
      <div class="shrink-0 w-6 text-center">
        @if (locked()) {
          <span class="text-xl opacity-50">🔒</span>
        } @else {
          <save-indicator [state]="saveState"></save-indicator>
        }
      </div>
    </div>
  `,
})
export class GroupBetRow {
  private readonly store = inject(SignalStore);
  private readonly betSaveService = inject(BetSaveService);

  groupName = input.required<string>();
  label = input.required<string>();
  teams = input.required<Team[]>();
  initialFirst = input<string | null>(null);
  initialSecond = input<string | null>(null);
  locked = input<boolean>(false);

  firstPlaceTeamId: string | null = null;
  secondPlaceTeamId: string | null = null;
  saveState: SaveState = { saving: false, saved: false };

  private initialized = false;

  private ensureInit() {
    if (this.initialized) return;
    this.initialized = true;
    this.firstPlaceTeamId = this.initialFirst();
    this.secondPlaceTeamId = this.initialSecond();
  }

  availableForFirst(): Team[] {
    this.ensureInit();
    return this.teams().filter((t) => t.id !== this.secondPlaceTeamId);
  }

  availableForSecond(): Team[] {
    this.ensureInit();
    return this.teams().filter((t) => t.id !== this.firstPlaceTeamId);
  }

  onFirstChange(teamId: string) {
    this.firstPlaceTeamId = teamId;
    this.saveIfComplete();
  }

  onSecondChange(teamId: string) {
    this.secondPlaceTeamId = teamId;
    this.saveIfComplete();
  }

  private saveIfComplete() {
    const userId = this.store.appuser()?.id;
    if (!userId || !this.firstPlaceTeamId || !this.secondPlaceTeamId) return;

    const body: GroupWinnerBetRequest = {
      userId,
      groupName: this.groupName(),
      firstPlaceTeamId: this.firstPlaceTeamId,
      secondPlaceTeamId: this.secondPlaceTeamId,
    };

    this.betSaveService
      .save<GroupWinnerBet>(API.GROUP_WINNER_BETS.SAVE(), body, this.saveState)
      .subscribe({
        error: (err) => console.error('Failed to save group winner bet', err),
      });
  }
}
