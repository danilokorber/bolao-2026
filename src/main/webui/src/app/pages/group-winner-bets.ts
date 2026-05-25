import { httpResource } from '@angular/common/http';
import { Component, computed, DestroyRef, effect, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { GroupBetCard } from '@components/group-bet-card';
import { GroupName, GroupWinnerBet, Team } from '@interfaces/index';
import { TeamService } from '@services/team.service';
import { utcDate } from '@utils/date-utils';
import { SignalStore } from '../store/signal-store';

interface GroupData {
  groupName: GroupName;
  label: string;
  teams: Team[];
  firstPlaceTeamId: string | null;
  secondPlaceTeamId: string | null;
  locked: boolean;
}

@Component({
  selector: 'group-winner-bets',
  imports: [TranslocoPipe, GroupBetCard],
  templateUrl: './group-winner-bets.html',
})
export class GroupWinnerBets {
  private readonly store = inject(SignalStore);
  private readonly teamService = inject(TeamService);
  private readonly router = inject(Router);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly now = signal(Date.now());

  constructor() {
    const interval = setInterval(() => this.now.set(Date.now()), 30_000);
    this.destroyRef.onDestroy(() => clearInterval(interval));
  }

  protected refreshNow() { this.now.set(Date.now()); }

  private userId = computed(() => this.store.appuser()?.id);

  next() {
    this.router.navigate(['/champion-bet']);
  }

  teams = httpResource<Team[]>(() => API.TEAMS.GET_ALL());
  userBets = httpResource<GroupWinnerBet[]>(() => {
    const id = this.userId();
    return id ? API.GROUP_WINNER_BETS.GET_BY_USER(id) : undefined;
  });
  deadlines = httpResource<Record<string, string>>(() => API.GROUP_WINNER_BETS.GET_DEADLINES());

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
    const deadlineMap = this.deadlines.value() ?? {};
    const now = this.now();

    return Object.values(GroupName).map((gn) => {
      const groupTeams = this.teamService.sortByName(
        allTeams.filter((t) => t.groupName === gn)
      );
      const existingBet = bets.find((b) => b.groupName === gn);
      const deadline = deadlineMap[gn];
      const locked = deadline ? now >= utcDate(deadline).getTime() : false;

      return {
        groupName: gn,
        label: gn.replace('GROUP_', ''),
        teams: groupTeams,
        firstPlaceTeamId: existingBet?.firstPlaceTeamId ?? null,
        secondPlaceTeamId: existingBet?.secondPlaceTeamId ?? null,
        locked,
      };
    });
  });
}
