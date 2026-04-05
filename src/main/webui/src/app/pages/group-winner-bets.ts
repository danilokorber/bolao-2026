import { HttpClient, httpResource } from '@angular/common/http';
import { Component, computed, effect, inject } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { API } from '@api/api';
import { TeamSelect } from '@components/team-select';
import { GroupName, GroupWinnerBet, GroupWinnerBetRequest, Team } from '@interfaces/index';
import { SignalStore } from '../store/signal-store';

interface GroupData {
  groupName: GroupName;
  label: string;
  teams: Team[];
  firstPlaceTeamId: string | null;
  secondPlaceTeamId: string | null;
  saving: boolean;
  saved: boolean;
}

@Component({
  selector: 'group-winner-bets',
  imports: [TranslocoPipe, TeamSelect],
  templateUrl: './group-winner-bets.html',
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
export class GroupWinnerBets {
  private readonly http = inject(HttpClient);
  private readonly store = inject(SignalStore);
  private readonly transloco = inject(TranslocoService);
  private readonly router = inject(Router);

  private userId = computed(() => this.store.appuser()?.id);

  next() {
    this.router.navigate(['/champion-bet']);
  }

  teams = httpResource<Team[]>(() => API.TEAMS.GET_ALL());
  userBets = httpResource<GroupWinnerBet[]>(() => {
    const id = this.userId();
    return id ? API.GROUP_WINNER_BETS.GET_BY_USER(id) : undefined;
  });

  private readonly redirectIfComplete = effect(() => {
    const bets = this.userBets.value();
    if (!bets) return;
    const totalGroups = Object.values(GroupName).length;
    if (bets.length >= totalGroups) {
      this.next();
    }
  });

  groups = computed<GroupData[]>(() => {
    const allTeams = this.teams.value() ?? [];
    const bets = this.userBets.value() ?? [];

    return Object.values(GroupName).map((gn) => {
      const groupTeams = allTeams
        .filter((t) => t.groupName === gn)
        .sort((a, b) => this.localizedName(a).localeCompare(this.localizedName(b)));
      const existingBet = bets.find((b) => b.groupName === gn);

      return {
        groupName: gn,
        label: gn.replace('GROUP_', ''),
        teams: groupTeams,
        firstPlaceTeamId: existingBet?.firstPlaceTeamId ?? null,
        secondPlaceTeamId: existingBet?.secondPlaceTeamId ?? null,
        saving: false,
        saved: false,
      };
    });
  });

  localizedName(team: Team): string {
    const lang = this.transloco.getActiveLang();
    switch (lang) {
      case 'de':
        return team.nameDe;
      case 'pt':
        return team.namePt;
      default:
        return team.nameEn;
    }
  }

  availableForFirst(group: GroupData): Team[] {
    return group.teams.filter((t) => t.id !== group.secondPlaceTeamId);
  }

  availableForSecond(group: GroupData): Team[] {
    return group.teams.filter((t) => t.id !== group.firstPlaceTeamId);
  }

  onFirstPlaceChange(group: GroupData, teamId: string) {
    group.firstPlaceTeamId = teamId;
    this.onSelectionChange(group);
  }

  onSecondPlaceChange(group: GroupData, teamId: string) {
    group.secondPlaceTeamId = teamId;
    this.onSelectionChange(group);
  }

  onSelectionChange(group: GroupData) {
    if (!group.firstPlaceTeamId || !group.secondPlaceTeamId) return;
    this.saveGroupBet(group);
  }

  private saveGroupBet(group: GroupData) {
    const userId = this.userId();
    if (!userId || !group.firstPlaceTeamId || !group.secondPlaceTeamId) return;

    group.saving = true;
    group.saved = false;

    const body: GroupWinnerBetRequest = {
      userId,
      groupName: group.groupName,
      firstPlaceTeamId: group.firstPlaceTeamId,
      secondPlaceTeamId: group.secondPlaceTeamId,
    };

    this.http.post<GroupWinnerBet>(API.GROUP_WINNER_BETS.SAVE(), body).subscribe({
      next: () => {
        group.saving = false;
        group.saved = true;
        setTimeout(() => (group.saved = false), 2500);
      },
      error: (err) => {
        group.saving = false;
        console.error('Failed to save group winner bet', err);
      },
    });
  }
}
