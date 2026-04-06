import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { Card } from '@components/card';
import { HistoryEntry } from '@components/points-progression-chart';
import { PointsProgressionChart } from '@components/points-progression-chart';
import { PositionHistoryChart } from '@components/position-history-chart';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { ScoreService } from '@services/score.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'ranking-page',
  imports: [TranslocoPipe, RouterLink, PointsProgressionChart, PositionHistoryChart, Card],
  templateUrl: './ranking.html',
})
export class RankingPage {
  private readonly store = inject(SignalStore);
  readonly scoreService = inject(ScoreService);

  ranking = httpResource<RankingEntry[]>(() => API.RANKING.GET_ALL());
  history = httpResource<HistoryEntry[]>(() => API.RANKING.GET_HISTORY());
  currentUserId = computed(() => this.store.appuser()?.id);

  chartUsers = computed(() => {
    const entries = this.ranking.value() ?? [];
    const userId = this.currentUserId();
    const top5 = entries.slice(0, 5);
    const userInTop5 = top5.some(e => e.userId === userId);
    if (!userInTop5 && userId) {
      const userEntry = entries.find(e => e.userId === userId);
      if (userEntry) top5.push(userEntry);
    }
    return top5;
  });
}
