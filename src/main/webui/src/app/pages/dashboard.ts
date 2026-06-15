import { Component } from '@angular/core';
import { BonusBetsChampionsAlert } from '@components/bonus-bets-champions-alert';
import { BonusBetsGroupsAlert } from '@components/bonus-bets-groups-alert';
import { RankingCard } from '@components/ranking-card';
import { RecentResultsCard } from '@components/recent-results-card';
import { UpcomingMatchesCard } from '@components/upcoming-matches-card';
import { LiveMatchesCard } from './../components/live-matches-card';

@Component({
  selector: 'dashboard',
  imports: [
    RankingCard,
    RecentResultsCard,
    LiveMatchesCard,
    UpcomingMatchesCard,
    BonusBetsChampionsAlert,
    BonusBetsGroupsAlert,
  ],
  templateUrl: './dashboard.html',
  styles: ``,
})
export class Dashboard {}
