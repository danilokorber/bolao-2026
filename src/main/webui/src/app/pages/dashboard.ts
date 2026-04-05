import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { RankingCard } from '@components/ranking-card';
import { RecentResultsCard } from '@components/recent-results-card';
import { UpcomingMatchesCard } from '@components/upcoming-matches-card';
import { Bet, ChampionBet, GroupWinnerBet, Match } from '@interfaces/index';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { resourceValueOr404 } from '@utils/resource-utils';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'dashboard',
  imports: [RankingCard, RecentResultsCard, UpcomingMatchesCard, TranslocoPipe, RouterLink],
  templateUrl: './dashboard.html',
  styles: ``,
})
export class Dashboard {
  private readonly store = inject(SignalStore);
  private userId = computed(() => this.store.appuser()?.id);

  matches = httpResource<Match[]>(() => API.MATCHES.GET_ALL(this.userId()));
  ranking = httpResource<RankingEntry[]>(() => API.RANKING.GET_ALL());
  bets = httpResource<Bet[]>(() => API.BETS.GET_ALL());

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
    return !!(bet.championTeamId && bet.runnerUpTeamId &&
      bet.semifinalist1TeamId && bet.semifinalist2TeamId &&
      bet.semifinalist3TeamId && bet.semifinalist4TeamId);
  });
}
