import { HttpClient, HttpErrorResponse, httpResource } from '@angular/common/http';
import { Component, computed, inject, signal, viewChild, ElementRef } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { API } from '@api/api';
import { TeamSelect } from '@components/team-select';
import { ChampionBet, ChampionBetRequest, GroupName, GroupWinnerBet, GroupWinnerBetRequest, Team } from '@interfaces/index';
import { SignalStore } from '../store/signal-store';
import { AVAILABLE_LANGS, LANG_LABELS } from '../config/transloco.config';

interface GroupRow {
  groupName: GroupName;
  label: string;
  teams: Team[];
  firstPlaceTeamId: string | null;
  secondPlaceTeamId: string | null;
  saving: boolean;
  saved: boolean;
}

@Component({
  selector: 'account',
  imports: [TranslocoPipe, TeamSelect],
  templateUrl: './account.html',
  styles: `
    .saved-flash {
      animation: flash 2.5s ease-in-out;
    }
    @keyframes flash {
      0%, 100% { opacity: 0; }
      10%, 70% { opacity: 1; }
    }
  `,
})
export class Account {
  private readonly router = inject(Router);
  private readonly http = inject(HttpClient);
  private readonly transloco = inject(TranslocoService);
  private readonly store = inject(SignalStore);

  scoringDialog = viewChild<ElementRef<HTMLDialogElement>>('scoringDialog');

  languages = AVAILABLE_LANGS.map((code) => ({ code, label: LANG_LABELS[code] }));
  activeLang = signal(this.transloco.getActiveLang());

  private userId = computed(() => this.store.appuser()?.id);

  allTeams = httpResource<Team[]>(() => API.TEAMS.GET_ALL());
  userGroupBets = httpResource<GroupWinnerBet[]>(() => {
    const id = this.userId();
    return id ? API.GROUP_WINNER_BETS.GET_BY_USER(id) : undefined;
  });

  // Champion bet
  private userChampionBetResource = httpResource<ChampionBet | null>(() => {
    const id = this.userId();
    return id ? API.CHAMPION_BETS.GET_BY_USER(id) : undefined;
  });

  championBet = computed(() => {
    const error = this.userChampionBetResource.error() as HttpErrorResponse | null;
    if (error && error.status === 404) return null;
    return this.userChampionBetResource.value() ?? null;
  });

  championBetLoaded = computed(() => {
    const error = this.userChampionBetResource.error() as HttpErrorResponse | null;
    if (error && error.status === 404) return true;
    return this.userChampionBetResource.hasValue();
  });

  semifinalist1TeamId: string | null = null;
  semifinalist2TeamId: string | null = null;
  semifinalist3TeamId: string | null = null;
  semifinalist4TeamId: string | null = null;
  championTeamId: string | null = null;
  runnerUpTeamId: string | null = null;
  championSaving = false;
  championSaved = false;
  championInitialized = false;

  groupRows = computed<GroupRow[]>(() => {
    const teams = this.allTeams.value() ?? [];
    const bets = this.userGroupBets.value() ?? [];

    return Object.values(GroupName).map((gn) => {
      const groupTeams = teams
        .filter((t) => t.groupName === gn)
        .sort((a, b) => this.localizedName(a).localeCompare(this.localizedName(b)));
      const bet = bets.find((b) => b.groupName === gn);

      return {
        groupName: gn,
        label: gn.replace('GROUP_', ''),
        teams: groupTeams,
        firstPlaceTeamId: bet?.firstPlaceTeamId ?? null,
        secondPlaceTeamId: bet?.secondPlaceTeamId ?? null,
        saving: false,
        saved: false,
      };
    });
  });

  private localizedName(team: Team): string {
    const lang = this.transloco.getActiveLang();
    switch (lang) {
      case 'de': return team.nameDe;
      case 'pt': return team.namePt;
      default: return team.nameEn;
    }
  }

  availableForFirst(row: GroupRow): Team[] {
    return row.teams.filter((t) => t.id !== row.secondPlaceTeamId);
  }

  availableForSecond(row: GroupRow): Team[] {
    return row.teams.filter((t) => t.id !== row.firstPlaceTeamId);
  }

  onFirstPlaceChange(row: GroupRow, teamId: string) {
    row.firstPlaceTeamId = teamId;
    this.saveIfComplete(row);
  }

  onSecondPlaceChange(row: GroupRow, teamId: string) {
    row.secondPlaceTeamId = teamId;
    this.saveIfComplete(row);
  }

  private saveIfComplete(row: GroupRow) {
    const userId = this.userId();
    if (!userId || !row.firstPlaceTeamId || !row.secondPlaceTeamId) return;

    row.saving = true;
    row.saved = false;

    const body: GroupWinnerBetRequest = {
      userId,
      groupName: row.groupName,
      firstPlaceTeamId: row.firstPlaceTeamId,
      secondPlaceTeamId: row.secondPlaceTeamId,
    };

    this.http.post<GroupWinnerBet>(API.GROUP_WINNER_BETS.SAVE(), body).subscribe({
      next: () => {
        row.saving = false;
        row.saved = true;
        setTimeout(() => (row.saved = false), 2500);
      },
      error: (err) => {
        row.saving = false;
        console.error('Failed to save group winner bet', err);
      },
    });
  }

  // Champion bet helpers
  initChampionBet() {
    if (this.championInitialized) return;
    const bet = this.championBet();
    this.championInitialized = true;
    if (!bet) return;
    this.semifinalist1TeamId = bet.semifinalist1TeamId ?? null;
    this.semifinalist2TeamId = bet.semifinalist2TeamId ?? null;
    this.semifinalist3TeamId = bet.semifinalist3TeamId ?? null;
    this.semifinalist4TeamId = bet.semifinalist4TeamId ?? null;
    this.championTeamId = bet.championTeamId ?? null;
    this.runnerUpTeamId = bet.runnerUpTeamId ?? null;
  }

  private selectedSemiIds(): string[] {
    return [this.semifinalist1TeamId, this.semifinalist2TeamId, this.semifinalist3TeamId, this.semifinalist4TeamId]
      .filter((id): id is string => !!id);
  }

  availableForSemi(excludeSlot: number): Team[] {
    const all = this.allTeams.value() ?? [];
    const selected = this.selectedSemiIds();
    const slots = [this.semifinalist1TeamId, this.semifinalist2TeamId, this.semifinalist3TeamId, this.semifinalist4TeamId];
    const current = slots[excludeSlot];
    return all.filter((t) => t.id === current || !selected.includes(t.id!));
  }

  availableForChampion(): Team[] {
    return (this.allTeams.value() ?? []).filter((t) => t.id !== this.runnerUpTeamId);
  }

  availableForRunnerUp(): Team[] {
    return (this.allTeams.value() ?? []).filter((t) => t.id !== this.championTeamId);
  }

  onSemiChange(slot: number, teamId: string) {
    switch (slot) {
      case 0: this.semifinalist1TeamId = teamId; break;
      case 1: this.semifinalist2TeamId = teamId; break;
      case 2: this.semifinalist3TeamId = teamId; break;
      case 3: this.semifinalist4TeamId = teamId; break;
    }
    this.saveChampionBet();
  }

  onChampionChange(teamId: string) {
    this.championTeamId = teamId;
    this.saveChampionBet();
  }

  onRunnerUpChange(teamId: string) {
    this.runnerUpTeamId = teamId;
    this.saveChampionBet();
  }

  private saveChampionBet() {
    const userId = this.userId();
    if (!userId) return;

    this.championSaving = true;
    this.championSaved = false;

    const body: ChampionBetRequest = {
      userId,
      championTeamId: this.championTeamId ?? undefined,
      runnerUpTeamId: this.runnerUpTeamId ?? undefined,
      semifinalist1TeamId: this.semifinalist1TeamId ?? undefined,
      semifinalist2TeamId: this.semifinalist2TeamId ?? undefined,
      semifinalist3TeamId: this.semifinalist3TeamId ?? undefined,
      semifinalist4TeamId: this.semifinalist4TeamId ?? undefined,
    };

    this.http.post<ChampionBet>(API.CHAMPION_BETS.SAVE(), body).subscribe({
      next: () => {
        this.championSaving = false;
        this.championSaved = true;
        setTimeout(() => (this.championSaved = false), 2500);
      },
      error: (err) => {
        this.championSaving = false;
        console.error('Failed to save champion bet', err);
      },
    });
  }

  changeLang(lang: string) {
    this.transloco.setActiveLang(lang);
    this.activeLang.set(lang);
    localStorage.setItem('lang', lang);
  }

  openScoringDialog() {
    this.scoringDialog()?.nativeElement.showModal();
  }

  closeScoringDialog() {
    this.scoringDialog()?.nativeElement.close();
  }

  onDialogBackdropClick(event: MouseEvent) {
    const dialog = this.scoringDialog()?.nativeElement;
    if (event.target === dialog) {
      dialog?.close();
    }
  }

  logout() {
    this.router.navigate(['/logout']);
  }
}
