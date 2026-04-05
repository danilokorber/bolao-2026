import { httpResource } from '@angular/common/http';
import { Component } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { RankingCard } from '@components/ranking-card';
import { RecentResultsCard } from '@components/recent-results-card';
import { UpcomingMatchesCard } from '@components/upcoming-matches-card';
import { Bet, Match } from '@interfaces/index';
import { RankingEntry } from '@interfaces/ranking-entry.interface';

@Component({
  selector: 'dashboard',
  imports: [RankingCard, RecentResultsCard, UpcomingMatchesCard, TranslocoPipe],
  templateUrl: './dashboard.html',
  styles: ``,
})
export class Dashboard {
  matches = httpResource<Match[]>(() => API.MATCHES.GET_ALL());
  ranking = httpResource<RankingEntry[]>(() => API.RANKING.GET_ALL());
  bets = httpResource<Bet[]>(() => API.BETS.GET_ALL());
}
