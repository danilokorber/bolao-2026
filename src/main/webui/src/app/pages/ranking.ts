import { HttpClient, httpResource } from '@angular/common/http';
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
import { lastValueFrom } from 'rxjs';
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
  private readonly http = inject(HttpClient);
  readonly scoreService = inject(ScoreService);

  private poolId = computed(() => this.store.currentPoolId?.());
  currentUserId = computed(() => this.store.appuser()?.id);

  ranking = httpResource<RankingEntry[]>(() => {
    const pid = this.poolId();
    const userId = this.currentUserId();
    return pid ? API.RANKING.GET_BY_POOL(pid, userId) : API.RANKING.GET_ALL(userId);
  });
  rankingOnlyActive = computed(() => {
    const entries = this.ranking.value() ?? [];
    return entries
      .filter(
        (e) =>
          e.countExact +
            e.countDiff +
            e.countWinner +
            e.countInverted +
            e.countWrong +
            e.specialPoints >
          0,
      )
      .map((e, i) => ({ ...e, position: i + 1 }));
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

  async toggleFavorite(entry: RankingEntry, event: Event): Promise<void> {
    event.preventDefault();
    event.stopPropagation();

    const userId = this.currentUserId();
    if (!userId || entry.userId === userId) {
      return;
    }

    await lastValueFrom(
      this.http.post(API.USERS.TOGGLE_FAVORITE(entry.userId), {
        userId,
      }),
    );
    this.ranking.reload();
  }

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
