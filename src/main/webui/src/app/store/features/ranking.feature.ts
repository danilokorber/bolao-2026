import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable } from '@angular/core';
import { API } from '@api/api';
import { HistoryEntry } from '@components/points-progression-chart';
import { RankingEntry } from '@interfaces/index';
import {
  patchState,
  signalStoreFeature,
  withComputed,
  withMethods,
  withState,
} from '@ngrx/signals';
import { lastValueFrom } from 'rxjs';

export const RANKING_REFRESH_INTERVAL = Math.random() * 30000 + 30000; // Random interval between 30s and 60s to prevent thundering herd on backend

@Injectable({
  providedIn: 'root',
})
export class SignalStoreRankingService {
  private readonly http = inject(HttpClient);
  public getRanking(): Promise<RankingEntry[]> {
    return lastValueFrom(this.http.get<RankingEntry[]>(API.RANKING.GET_ALL()));
  }
  public getHistory(): Promise<HistoryEntry[]> {
    return lastValueFrom(this.http.get<HistoryEntry[]>(API.RANKING.GET_HISTORY()));
  }
}

export function withRankingFeature() {
  return signalStoreFeature(
    withState({
      ranking: [] as RankingEntry[],
      history: [] as HistoryEntry[],
      rankingInitiallyLoaded: false,
    }),

    withComputed(({ ranking, history, rankingInitiallyLoaded }) => ({
      rankingLoaded: computed<boolean>(() => rankingInitiallyLoaded()),
      rankingSorted: computed<RankingEntry[]>(() => {
        const list = Array.isArray(ranking()) ? ranking() : [];
        return [...list]
          .filter(
            (e) =>
              e.countExact + e.countWinner + e.countDiff + e.countInverted + e.countWrong > 0 ||
              e.specialPoints > 0,
          )
          .sort((a, b) => b.totalPoints - a.totalPoints)
          .map((e, i) => ({ ...e, position: i + 1 }));
      }),
      history: computed<HistoryEntry[]>(() => history()),
    })),

    withMethods((store) => {
      const service = inject(SignalStoreRankingService);

      return {
        async loadRanking() {
          try {
            const ranking = await service.getRanking();
            patchState(store, { ranking, rankingInitiallyLoaded: true });
          } catch (error) {
            // On error, keep last known state — prevents false "no matches" signals
            console.error('Failed to refresh ranking:', error);
          }
        },
        async loadHistory() {
          try {
            const history = await service.getHistory();
            patchState(store, { history });
          } catch (error) {
            console.error('Failed to refresh history:', error);
          }
        },
      };
    }),
  );
}
