import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { API } from '@api/api';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, Team } from '@interfaces/index';
import { MatchStatus } from '@interfaces/match-status.enum';
import { ScoreService } from '@services/score.service';
import { TeamService } from '@services/team.service';
import { utcDate } from '@utils/date-utils';
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
  protected readonly scoreService = inject(ScoreService);

  private readonly targetUserId = this.route.snapshot.paramMap.get('userId') ?? '';

  userBets = httpResource<Bet[]>(() =>
    this.targetUserId ? API.BETS.GET_BY_USER(this.targetUserId) : undefined
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

  localizedName(team?: Team): string {
    return team ? this.teamService.localizedName(team) : '';
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
