import { Component, computed, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { Card } from '@components/card';
import { PointsProgressionChart } from '@components/points-progression-chart';
import { PositionHistoryChart } from '@components/position-history-chart';
import { RankingItemSkeleton } from '@components/ranking-item-skeleton';
import { TranslocoPipe } from '@jsverse/transloco';
import { ScoreService } from '@services/score.service';
import { UserFavoriteService } from '../services/user-favorite.service';
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
  readonly store = inject(SignalStore);
  readonly scoreService = inject(ScoreService);
  private favoriteService = inject(UserFavoriteService);

  private poolId = computed(() => this.store.currentPoolId?.());

  showFavorite = signal(false);

  ranking = this.store.rankingSorted;

  history = this.store.history;

  toggleFavorite(userId: string) {
    this.favoriteService.toggleFavorite(userId).subscribe((response) => {
      console.log('Is now favorite:', response.isFavorite);
      this.store.loadRanking();
    });
  }

  currentUserId = computed(() => this.store.appuser()?.id);

  chartUsers = computed(() => {
    const entries = this.ranking() ?? [];
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
