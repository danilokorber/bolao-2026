import { Component, inject, input } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { TeamSelect } from '@components/team-select';
import { SaveIndicator } from '@components/save-indicator';
import { GroupWinnerBet, GroupWinnerBetRequest, Team } from '@interfaces/index';
import { BetSaveService, SaveState } from '@services/bet-save.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'group-bet-card',
  imports: [TranslocoPipe, TeamSelect, SaveIndicator],
  template: `
    <div class="border border-gray-200 rounded-xl bg-white shadow-sm">
      <!-- Group header -->
      <div
        class="flex items-center justify-between px-4 py-2 bg-primary-700 text-white rounded-t-xl"
      >
        <h2 class="text-lg font-bold">{{ 'groupWinnerBets.group' | transloco }} {{ label() }}</h2>
        @if (locked()) {
          <span class="text-xs opacity-70">🔒 {{ 'groupWinnerBets.locked' | transloco }}</span>
        } @else {
          <save-indicator [state]="saveState"></save-indicator>
        }
      </div>

      <!-- Bet selectors -->
      <div class="px-4 py-3 flex flex-col gap-3">
        <div>
          <label class="text-lg font-semibold text-primary-700 uppercase tracking-wide">
            🥇 {{ 'groupWinnerBets.firstPlace' | transloco }}
          </label>
          <div class="mt-1">
            <team-select
              [teams]="availableForFirst()"
              [value]="firstPlaceTeamId"
              [placeholder]="'groupWinnerBets.selectTeam' | transloco"
              [disabled]="locked()"
              (selected)="onFirstChange($event)"
            ></team-select>
          </div>
        </div>
        <div>
          <label class="text-lg font-semibold text-primary-700 uppercase tracking-wide">
            🥈 {{ 'groupWinnerBets.secondPlace' | transloco }}
          </label>
          <div class="mt-1">
            <team-select
              [teams]="availableForSecond()"
              [value]="secondPlaceTeamId"
              [placeholder]="'groupWinnerBets.selectTeam' | transloco"
              [disabled]="locked()"
              (selected)="onSecondChange($event)"
            ></team-select>
          </div>
        </div>
      </div>
    </div>
  `,
})
export class GroupBetCard {
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
