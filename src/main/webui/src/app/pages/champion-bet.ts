import { HttpClient, HttpErrorResponse, httpResource } from '@angular/common/http';
import { Component, computed, effect, inject } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { TeamSelect } from '@components/team-select';
import { ChampionBet, ChampionBetRequest, Team } from '@interfaces/index';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'champion-bet',
  imports: [TranslocoPipe, TeamSelect],
  templateUrl: './champion-bet.html',
  styles: `
    .saved-flash {
      animation: flash 2.5s ease-in-out;
    }
    @keyframes flash {
      0%,
      100% {
        opacity: 0;
      }
      10%,
      70% {
        opacity: 1;
      }
    }
  `,
})
export class ChampionBetPage {
  private readonly http = inject(HttpClient);
  private readonly store = inject(SignalStore);
  private readonly router = inject(Router);

  private userId = computed(() => this.store.appuser()?.id);

  next() {
    this.router.navigate(['/dashboard']);
  }

  teams = httpResource<Team[]>(() => API.TEAMS.GET_ALL());

  userBet = httpResource<ChampionBet | null>(() => {
    const id = this.userId();
    return id ? API.CHAMPION_BETS.GET_BY_USER(id) : undefined;
  });

  // Handle 404 as "no bet yet" instead of error
  betValue = computed(() => {
    const error = this.userBet.error() as HttpErrorResponse | null;
    if (error && error.status === 404) return null;
    return this.userBet.value() ?? null;
  });

  betLoaded = computed(() => {
    const error = this.userBet.error() as HttpErrorResponse | null;
    if (error && error.status === 404) return true; // 404 means loaded but empty
    return this.userBet.hasValue();
  });

  // Redirect if bet is already complete (all 6 slots filled)
  private readonly redirectIfComplete = effect(() => {
    const bet = this.betValue();
    if (!bet) return;
    if (
      bet.championTeamId &&
      bet.runnerUpTeamId &&
      bet.semifinalist1TeamId &&
      bet.semifinalist2TeamId &&
      bet.semifinalist3TeamId &&
      bet.semifinalist4TeamId
    ) {
      this.next();
    }
  });

  semifinalist1TeamId: string | null = null;
  semifinalist2TeamId: string | null = null;
  semifinalist3TeamId: string | null = null;
  semifinalist4TeamId: string | null = null;
  championTeamId: string | null = null;
  runnerUpTeamId: string | null = null;
  saving = false;
  saved = false;
  initialized = false;

  private initEffect = effect(() => {
    const bet = this.betValue();
    if (this.initialized) return;
    if (!this.betLoaded()) return;
    this.initialized = true;
    if (!bet) return;
    this.semifinalist1TeamId = bet.semifinalist1TeamId ?? null;
    this.semifinalist2TeamId = bet.semifinalist2TeamId ?? null;
    this.semifinalist3TeamId = bet.semifinalist3TeamId ?? null;
    this.semifinalist4TeamId = bet.semifinalist4TeamId ?? null;
    this.championTeamId = bet.championTeamId ?? null;
    this.runnerUpTeamId = bet.runnerUpTeamId ?? null;
  });

  allTeams = computed(() => this.teams.value() ?? []);

  private selectedSemiIds(): string[] {
    return [
      this.semifinalist1TeamId,
      this.semifinalist2TeamId,
      this.semifinalist3TeamId,
      this.semifinalist4TeamId,
    ].filter((id): id is string => !!id);
  }

  availableForSemi(excludeSlot: number): Team[] {
    const selected = this.selectedSemiIds();
    const slots = [
      this.semifinalist1TeamId,
      this.semifinalist2TeamId,
      this.semifinalist3TeamId,
      this.semifinalist4TeamId,
    ];
    const current = slots[excludeSlot];
    return this.allTeams().filter((t) => t.id === current || !selected.includes(t.id!));
  }

  availableForChampion(): Team[] {
    return this.allTeams().filter((t) => t.id !== this.runnerUpTeamId);
  }

  availableForRunnerUp(): Team[] {
    return this.allTeams().filter((t) => t.id !== this.championTeamId);
  }

  onSemiChange(slot: number, teamId: string) {
    switch (slot) {
      case 0:
        this.semifinalist1TeamId = teamId;
        break;
      case 1:
        this.semifinalist2TeamId = teamId;
        break;
      case 2:
        this.semifinalist3TeamId = teamId;
        break;
      case 3:
        this.semifinalist4TeamId = teamId;
        break;
    }
    this.autoSave();
  }

  onChampionChange(teamId: string) {
    this.championTeamId = teamId;
    this.autoSave();
  }

  onRunnerUpChange(teamId: string) {
    this.runnerUpTeamId = teamId;
    this.autoSave();
  }

  private autoSave() {
    const userId = this.userId();
    if (!userId) return;

    // Save whenever any field changes (partial saves allowed)
    const body: ChampionBetRequest = {
      userId,
      championTeamId: this.championTeamId ?? undefined,
      runnerUpTeamId: this.runnerUpTeamId ?? undefined,
      semifinalist1TeamId: this.semifinalist1TeamId ?? undefined,
      semifinalist2TeamId: this.semifinalist2TeamId ?? undefined,
      semifinalist3TeamId: this.semifinalist3TeamId ?? undefined,
      semifinalist4TeamId: this.semifinalist4TeamId ?? undefined,
    };

    this.saving = true;
    this.saved = false;

    this.http.post<ChampionBet>(API.CHAMPION_BETS.SAVE(), body).subscribe({
      next: () => {
        this.saving = false;
        this.saved = true;
        setTimeout(() => (this.saved = false), 2500);
      },
      error: (err) => {
        this.saving = false;
        console.error('Failed to save champion bet', err);
      },
    });
  }
}
