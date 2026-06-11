import { httpResource } from '@angular/common/http';
import { Component, computed, DestroyRef, inject, signal, viewChild } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { API } from '@api/api';
import { ChampionBetForm } from '@components/champion-bet-form';
import { GroupBetRow } from '@components/group-bet-row';
import { ScoringDialog } from '@components/scoring-dialog';
import { ChampionBet, GroupName, GroupWinnerBet, Team } from '@interfaces/index';
import { NotificationPreference } from '@interfaces/notification-preference.interface';
import { NotificationService } from '@services/notification.service';
import { TeamService } from '@services/team.service';
import { utcDate } from '@utils/date-utils';
import { resourceLoadedOr404, resourceValueOr404 } from '@utils/resource-utils';
import { firstValueFrom } from 'rxjs';
import { SignalStore } from '../store/signal-store';
import { AVAILABLE_LANGS, LANG_LABELS } from '../config/transloco.config';

interface GroupRow {
  groupName: GroupName;
  label: string;
  teams: Team[];
  firstPlaceTeamId: string | null;
  secondPlaceTeamId: string | null;
  locked: boolean;
}

@Component({
  selector: 'account',
  imports: [TranslocoPipe, GroupBetRow, ChampionBetForm, ScoringDialog],
  templateUrl: './account.html',
})
export class Account {
  private readonly router = inject(Router);
  private readonly transloco = inject(TranslocoService);
  private readonly store = inject(SignalStore);
  private readonly teamService = inject(TeamService);
  private readonly notificationService = inject(NotificationService);
  private readonly destroyRef = inject(DestroyRef);

  protected readonly now = signal(Date.now());

  constructor() {
    const interval = setInterval(() => this.now.set(Date.now()), 30_000);
    this.destroyRef.onDestroy(() => clearInterval(interval));
    this.loadNotificationSettings();
  }

  protected refreshNow() { this.now.set(Date.now()); }

  notificationPrefs = signal<NotificationPreference | null>(null);
  notificationLoading = signal(false);
  isPushSubscribed = signal(false);

  scoringDialogRef = viewChild<ScoringDialog>('scoringDialog');

  languages = AVAILABLE_LANGS.map((code) => ({ code, label: LANG_LABELS[code] }));
  activeLang = signal(this.transloco.getActiveLang());

  private userId = computed(() => this.store.appuser()?.id);

  allTeams = httpResource<Team[]>(() => API.TEAMS.GET_ALL());
  userGroupBets = httpResource<GroupWinnerBet[]>(() => {
    const id = this.userId();
    return id ? API.GROUP_WINNER_BETS.GET_BY_USER(id) : undefined;
  });
  deadlines = httpResource<Record<string, string>>(() => API.GROUP_WINNER_BETS.GET_DEADLINES());

  private userChampionBetResource = httpResource<ChampionBet | null>(() => {
    const id = this.userId();
    return id ? API.CHAMPION_BETS.GET_BY_USER(id) : undefined;
  });
  championDeadline = httpResource<{ deadline?: string }>(() => API.CHAMPION_BETS.GET_DEADLINE());

  championBet = computed(() => resourceValueOr404(this.userChampionBetResource));
  championBetLoaded = computed(() => resourceLoadedOr404(this.userChampionBetResource));
  allTeamsList = computed(() => this.allTeams.value() ?? []);

  championLocked = computed(() => {
    const d = this.championDeadline.value()?.deadline;
    return d ? this.now() >= utcDate(d).getTime() : false;
  });

  groupRows = computed<GroupRow[]>(() => {
    const teams = this.allTeams.value() ?? [];
    const bets = this.userGroupBets.value() ?? [];
    const deadlineMap = this.deadlines.value() ?? {};
    const now = this.now();

    return Object.values(GroupName).map((gn) => {
      const groupTeams = this.teamService.sortByName(
        teams.filter((t) => t.groupName === gn)
      );
      const bet = bets.find((b) => b.groupName === gn);
      const deadline = deadlineMap[gn];
      const locked = deadline ? now >= utcDate(deadline).getTime() : false;

      return {
        groupName: gn,
        label: gn.replace('GROUP_', ''),
        teams: groupTeams,
        firstPlaceTeamId: bet?.firstPlaceTeamId ?? null,
        secondPlaceTeamId: bet?.secondPlaceTeamId ?? null,
        locked,
      };
    });
  });

  changeLang(lang: string) {
    this.transloco.setActiveLang(lang);
    this.activeLang.set(lang);
    localStorage.setItem('lang', lang);
  }

  openScoringDialog() {
    this.scoringDialogRef()?.open();
  }

  logout() {
    this.router.navigate(['/logout']);
  }

  async toggleDaily() {
    const current = this.notificationPrefs();
    if (!current) return;
    await this.updateNotificationPrefs({
      ...current,
      dailyEnabled: !current.dailyEnabled,
    });
  }

  async toggleEvent() {
    const current = this.notificationPrefs();
    if (!current) return;
    await this.updateNotificationPrefs({
      ...current,
      eventEnabled: !current.eventEnabled,
    });
  }

  async togglePushSubscription() {
    this.notificationLoading.set(true);
    try {
      if (this.isPushSubscribed()) {
        await this.notificationService.unsubscribe();
        this.isPushSubscribed.set(false);
      } else {
        const subscribed = await this.notificationService.subscribe();
        this.isPushSubscribed.set(subscribed);
      }
    } finally {
      this.notificationLoading.set(false);
    }
  }

  private async loadNotificationSettings() {
    this.notificationLoading.set(true);
    try {
      const [prefs, subscribed] = await Promise.all([
        firstValueFrom(this.notificationService.getPreferences()),
        this.notificationService.isSubscribed(),
      ]);
      this.notificationPrefs.set(prefs);
      this.isPushSubscribed.set(subscribed);
    } finally {
      this.notificationLoading.set(false);
    }
  }

  private async updateNotificationPrefs(payload: NotificationPreference) {
    this.notificationLoading.set(true);
    try {
      const updated = await firstValueFrom(this.notificationService.updatePreferences(payload));
      this.notificationPrefs.set(updated);
    } finally {
      this.notificationLoading.set(false);
    }
  }
}
