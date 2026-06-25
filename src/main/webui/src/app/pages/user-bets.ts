import { httpResource } from '@angular/common/http';
import { Component, computed, DestroyRef, inject, signal } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { API } from '@api/api';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, ChampionBet, GroupWinnerBet, Team } from '@interfaces/index';
import { MatchStatus } from '@interfaces/match-status.enum';
import { ScoreService } from '@services/score.service';
import { TeamService } from '@services/team.service';
import { CHAMPION_BETS_REVEAL_AT_UTC } from '@utils/constants';
import { utcDate } from '@utils/date-utils';
import { resourceValueOr404 } from '@utils/resource-utils';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'user-bets-page',
  imports: [TranslocoPipe, FlagFallbackDirective, RouterLink],
  templateUrl: './user-bets.html',
  host: { class: 'flex flex-col gap-8 w-full mx-auto' },
})
export class UserBetsPage {
  private readonly route = inject(ActivatedRoute);
  private readonly transloco = inject(TranslocoService);
  private readonly store = inject(SignalStore);
  private readonly teamService = inject(TeamService);
  private readonly destroyRef = inject(DestroyRef);
  protected readonly scoreService = inject(ScoreService);

  private readonly now = signal(Date.now());
  private readonly championRevealAt = utcDate(CHAMPION_BETS_REVEAL_AT_UTC).getTime();

  constructor() {
    const interval = setInterval(() => this.now.set(Date.now()), 30_000);
    this.destroyRef.onDestroy(() => clearInterval(interval));
  }

  private readonly targetUserId = this.route.snapshot.paramMap.get('userId') ?? '';

  userBets = httpResource<Bet[]>(() =>
    this.targetUserId ? API.BETS.GET_BY_USER(this.targetUserId) : undefined
  );

  groupBets = httpResource<GroupWinnerBet[]>(() =>
    this.targetUserId ? API.GROUP_WINNER_BETS.GET_BY_USER(this.targetUserId) : undefined
  );

  championBetResource = httpResource<ChampionBet | null>(() =>
    this.targetUserId ? API.CHAMPION_BETS.GET_BY_USER(this.targetUserId) : undefined
  );

  sortedBets = computed(() => {
    const bets = this.userBets.value() ?? [];
    const now = Date.now();
    return bets
      .filter(b => {
        const status = b.match?.status;
        if (status !== MatchStatus.LIVE && status !== MatchStatus.FINISHED) return false;
        const kickoff = b.match?.matchDatetime ? utcDate(b.match.matchDatetime).getTime() : Infinity;
        return kickoff < now;
      })
      .sort((a, b) => {
        const dateA = utcDate(a.match?.matchDatetime ?? '').getTime();
        const dateB = utcDate(b.match?.matchDatetime ?? '').getTime();
        return dateB - dateA;
      });
  });

  userName = computed(() => {
    const bets = this.userBets.value() ?? [];
    return bets[0]?.user?.name ?? '';
  });

  totalPoints = computed(() =>
    this.sortedBets().reduce((sum, b) => sum + (b.pointsEarned ?? 0), 0)
  );

  sortedGroupBets = computed(() =>
    [...(this.groupBets.value() ?? [])].sort((a, b) => a.groupName.localeCompare(b.groupName))
  );

  groupBetsTotalPoints = computed(() =>
    this.sortedGroupBets().reduce((sum, b) => sum + (b.pointsEarned ?? 0), 0)
  );

  championBet = computed(() => resourceValueOr404(this.championBetResource));

  championSemifinalists = computed<Team[]>(() => {
    const bet = this.championBet();
    if (!bet) return [];
    return [
      bet.semifinalist1Team,
      bet.semifinalist2Team,
      bet.semifinalist3Team,
      bet.semifinalist4Team,
    ].filter((t): t is Team => !!t);
  });

  championBetVisible = computed(
    () => !!this.championBet() && this.now() >= this.championRevealAt
  );

  localizedName(team?: Team): string {
    return team ? this.teamService.localizedName(team) : '';
  }

  groupLabel(groupName: string): string {
    return groupName.replace('GROUP_', '');
  }

  formatDate(iso?: string): string {
    if (!iso) return '–';
    const d = utcDate(iso);
    return d.toLocaleDateString(this.transloco.getActiveLang(), {
      day: '2-digit',
      month: 'short',
      hour: '2-digit',
      minute: '2-digit',
    });
  }

  goBack(): void {
    window.history.back();
  }
}
