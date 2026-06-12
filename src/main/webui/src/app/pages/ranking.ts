import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { API } from '@api/api';
import { Card } from '@components/card';
import { HistoryEntry, PointsProgressionChart } from '@components/points-progression-chart';
import { PositionHistoryChart } from '@components/position-history-chart';
import { RankingItemSkeleton } from '@components/ranking-item-skeleton';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { TranslocoPipe } from '@jsverse/transloco';
import { ScoreService } from '@services/score.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'ranking-page',
  imports: [
    TranslocoPipe,
    RouterLink,
    PointsProgressionChart,
    PositionHistoryChart,
    Card,
    RankingItemSkeleton,
  ],
  templateUrl: './ranking.html',
})
export class RankingPage {
  private readonly store = inject(SignalStore);
  readonly scoreService = inject(ScoreService);

  private poolId = computed(() => this.store.currentPoolId?.());

  ranking = httpResource<RankingEntry[]>(() => {
    const pid = this.poolId();
    return pid ? API.RANKING.GET_BY_POOL(pid) : API.RANKING.GET_ALL();
  });

  history = httpResource<HistoryEntry[]>(() => {
    const pid = this.poolId();
    return pid ? API.RANKING.GET_HISTORY_BY_POOL(pid) : API.RANKING.GET_HISTORY();
  });

  constructor() {
    setInterval(
      () => {
        this.ranking.reload();
        this.history.reload();
      },
      Math.random() * 60_000 + 30_000,
    ); // Random delay between 30s and 90s
  }

  currentUserId = computed(() => this.store.appuser()?.id);

  chartUsers = computed(() => {
    const entries = this.ranking.value() ?? [];
    const userId = this.currentUserId();
    const top5 = entries.slice(0, 5);
    const userInTop5 = top5.some((e) => e.userId === userId);
    if (!userInTop5 && userId) {
      const userEntry = entries.find((e) => e.userId === userId);
      if (userEntry) top5.push(userEntry);
    }
    return top5;
  });
}
