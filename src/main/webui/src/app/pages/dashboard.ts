import { JsonPipe } from '@angular/common';
import { httpResource } from '@angular/common/http';
import { Component, computed, inject, linkedSignal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { API } from '@api/api';
import { RankingCard } from '@components/ranking-card';
import { RecentResultsCard } from '@components/recent-results-card';
import { UpcomingMatchesCard } from '@components/upcoming-matches-card';
import { ChampionBet, GroupWinnerBet, MatchStatus } from '@interfaces/index';
import { TranslocoPipe } from '@jsverse/transloco';
import { resourceValueOr404 } from '@utils/resource-utils';
import { SignalStore } from '../store/signal-store';
import { LiveMatchesCard } from './../components/live-matches-card';

@Component({
  selector: 'dashboard',
  imports: [
    RankingCard,
    RecentResultsCard,
    LiveMatchesCard,
    UpcomingMatchesCard,
    TranslocoPipe,
    RouterLink,
    JsonPipe,
  ],
  templateUrl: './dashboard.html',
  styles: ``,
})
export class Dashboard {
  readonly store = inject(SignalStore);
  userId = computed(() => this.store.appuser()?.id);

  matches = this.store.allMatches; // computed(() => this.matchesPage.value()?.content ?? []);
  bets = this.store.allBets; // computed(() => this.betsPage.value()?.content ?? []);

  hasLiveMatches = linkedSignal(() => this.matches().some((m) => m.status == MatchStatus.LIVE));

  groupBets = httpResource<GroupWinnerBet[]>(() => {
    const id = this.userId();
    return id ? API.GROUP_WINNER_BETS.GET_BY_USER(id) : undefined;
  });

  private championBetResource = httpResource<ChampionBet | null>(() => {
    const id = this.userId();
    return id ? API.CHAMPION_BETS.GET_BY_USER(id) : undefined;
  });

  groupBetsComplete = computed(() => (this.groupBets.value()?.length ?? 0) >= 12);

  championBetComplete = computed(() => {
    const bet = resourceValueOr404(this.championBetResource);
    if (!bet) return false;
    return !!(
      bet.championTeamId &&
      bet.runnerUpTeamId &&
      bet.semifinalist1TeamId &&
      bet.semifinalist2TeamId &&
      bet.semifinalist3TeamId &&
      bet.semifinalist4TeamId
    );
  });
}
