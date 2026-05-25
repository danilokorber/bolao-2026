import { Component, computed, effect, inject, input, output } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { TeamSelect } from '@components/team-select';
import { SaveIndicator } from '@components/save-indicator';
import { ChampionBet, ChampionBetRequest, Team } from '@interfaces/index';
import { BetSaveService, SaveState } from '@services/bet-save.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'champion-bet-form',
  imports: [TranslocoPipe, TeamSelect, SaveIndicator],
  template: `
    @if (mode() === 'card') {
      <!-- Card layout (standalone page) -->
      <div class="flex flex-col gap-6">
        <!-- Semifinalists card -->
        <div class="border border-gray-200 rounded-xl bg-white shadow-sm">
          <div
            class="flex items-center justify-between px-4 py-2 bg-primary-700 text-white rounded-t-xl"
          >
            <h2 class="text-lg font-bold">⚽ {{ 'championBet.semifinalists' | transloco }}</h2>
            @if (locked()) {
              <span class="text-xl opacity-70">🔒 {{ 'championBet.locked' | transloco }}</span>
            }
          </div>
          <div class="px-4 py-3 grid grid-cols-1 sm:grid-cols-2 gap-3">
            @for (i of semiSlots; track i) {
              <div>
                <div class="mt-1">
                  <team-select
                    [teams]="availableForSemi(i)"
                    [value]="semiIds[i]"
                    [placeholder]="'championBet.selectTeam' | transloco"
                    [disabled]="locked()"
                    (selected)="onSemiChange(i, $event)"
                    [filterable]="true"
                  ></team-select>
                </div>
              </div>
            }
          </div>
        </div>

        <!-- Champion & Runner-up card -->
        <div class="border border-gray-200 rounded-xl bg-white shadow-sm">
          <div
            class="flex items-center justify-between px-4 py-2 bg-secondary-600 text-white rounded-t-xl"
          >
            <h2 class="text-lg font-bold">🏆 {{ 'championBet.final' | transloco }}</h2>
            @if (locked()) {
              <span class="text-xs opacity-70">🔒 {{ 'championBet.locked' | transloco }}</span>
            } @else {
              <save-indicator [state]="saveState"></save-indicator>
            }
          </div>
          <div class="px-4 py-3 grid grid-cols-1 sm:grid-cols-2 gap-3">
            <div>
              <label class="text-xl font-semibold text-secondary-700 uppercase tracking-wide">
                🥇 {{ 'championBet.champion' | transloco }}
              </label>
              <div class="mt-1">
                <team-select
                  [teams]="availableForChampion()"
                  [value]="championTeamId"
                  [placeholder]="'championBet.selectTeam' | transloco"
                  [disabled]="locked()"
                  (selected)="onChampionChange($event)"
                  [filterable]="true"
                ></team-select>
              </div>
            </div>
            <div>
              <label class="text-xl font-semibold text-secondary-700 uppercase tracking-wide">
                🥈 {{ 'championBet.runnerUp' | transloco }}
              </label>
              <div class="mt-1">
                <team-select
                  [teams]="availableForRunnerUp()"
                  [value]="runnerUpTeamId"
                  [placeholder]="'championBet.selectTeam' | transloco"
                  [disabled]="locked()"
                  (selected)="onRunnerUpChange($event)"
                  [filterable]="true"
                ></team-select>
              </div>
            </div>
          </div>
        </div>
      </div>
    } @else {
      <!-- Compact layout (account page) -->
      <div class="flex flex-col gap-2">
        <h2 class="text-lg font-semibold text-gray-500 uppercase tracking-wide">
          ⚽ {{ 'championBet.semifinalists' | transloco }}
        </h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
          @for (i of semiSlots; track i) {
            <div class="flex items-center gap-2">
              <team-select
                class="flex-1"
                [teams]="availableForSemi(i)"
                [value]="semiIds[i]"
                [placeholder]="'championBet.selectTeam' | transloco"
                [disabled]="locked()"
                (selected)="onSemiChange(i, $event)"
                [filterable]="true"
              ></team-select>
            </div>
          }
        </div>
      </div>

      <div class="flex flex-col gap-2">
        <h2 class="text-lg font-semibold text-gray-500 uppercase tracking-wide">
          🏆 {{ 'championBet.final' | transloco }}
        </h2>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
          <div class="flex items-center gap-2">
            <span class="shrink-0 text-xl">🥇</span>
            <team-select
              class="flex-1"
              [teams]="availableForChampion()"
              [value]="championTeamId"
              [placeholder]="'championBet.selectTeam' | transloco"
              [disabled]="locked()"
              (selected)="onChampionChange($event)"
              [filterable]="true"
            ></team-select>
          </div>
          <div class="flex items-center gap-2">
            <span class="shrink-0 text-xl">🥈</span>
            <team-select
              class="flex-1"
              [teams]="availableForRunnerUp()"
              [value]="runnerUpTeamId"
              [placeholder]="'championBet.selectTeam' | transloco"
              [disabled]="locked()"
              (selected)="onRunnerUpChange($event)"
              [filterable]="true"
            ></team-select>
          </div>
        </div>
      </div>
    }
  `,
  host: { class: 'flex flex-col gap-4' },
})
export class ChampionBetForm {
  private readonly store = inject(SignalStore);
  private readonly betSaveService = inject(BetSaveService);

  mode = input<'card' | 'compact'>('card');
  teams = input.required<Team[]>();
  bet = input<ChampionBet | null | undefined>(null);
  locked = input<boolean>(false);
  deadlinePassed = output<void>();

  readonly semiSlots = [0, 1, 2, 3];
  semiIds: (string | null)[] = [null, null, null, null];
  championTeamId: string | null = null;
  runnerUpTeamId: string | null = null;
  saveState: SaveState = { saving: false, saved: false };

  private initialized = false;
  private userId = computed(() => this.store.appuser()?.id);

  private initEffect = effect(() => {
    const bet = this.bet();
    if (this.initialized || !bet) return;
    this.initialized = true;
    this.semiIds = [
      bet.semifinalist1TeamId ?? null,
      bet.semifinalist2TeamId ?? null,
      bet.semifinalist3TeamId ?? null,
      bet.semifinalist4TeamId ?? null,
    ];
    this.championTeamId = bet.championTeamId ?? null;
    this.runnerUpTeamId = bet.runnerUpTeamId ?? null;
  });

  private selectedSemiIds(): string[] {
    return this.semiIds.filter((id): id is string => !!id);
  }

  availableForSemi(excludeSlot: number): Team[] {
    const selected = this.selectedSemiIds();
    const current = this.semiIds[excludeSlot];
    return this.teams().filter((t) => t.id === current || !selected.includes(t.id!));
  }

  availableForChampion(): Team[] {
    return this.teams().filter((t) => t.id !== this.runnerUpTeamId);
  }

  availableForRunnerUp(): Team[] {
    return this.teams().filter((t) => t.id !== this.championTeamId);
  }

  onSemiChange(slot: number, teamId: string) {
    this.semiIds[slot] = teamId;
    this.save();
  }

  onChampionChange(teamId: string) {
    this.championTeamId = teamId;
    this.save();
  }

  onRunnerUpChange(teamId: string) {
    this.runnerUpTeamId = teamId;
    this.save();
  }

  private save() {
    const userId = this.userId();
    if (!userId) return;

    const body: ChampionBetRequest = {
      userId,
      championTeamId: this.championTeamId ?? undefined,
      runnerUpTeamId: this.runnerUpTeamId ?? undefined,
      semifinalist1TeamId: this.semiIds[0] ?? undefined,
      semifinalist2TeamId: this.semiIds[1] ?? undefined,
      semifinalist3TeamId: this.semiIds[2] ?? undefined,
      semifinalist4TeamId: this.semiIds[3] ?? undefined,
    };

    this.betSaveService
      .save<ChampionBet>(API.CHAMPION_BETS.SAVE(), body, this.saveState)
      .subscribe({
        error: (err) => {
          if (err.status === 400) this.deadlinePassed.emit();
          console.error('Failed to save champion bet', err);
        },
      });
  }
}
