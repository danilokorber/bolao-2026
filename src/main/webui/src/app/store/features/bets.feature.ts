import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable } from '@angular/core';
import { API } from '@api/api';
import { Bet, PagedResponse } from '@interfaces/index';
import {
  patchState,
  signalStoreFeature,
  withComputed,
  withMethods,
  withState,
} from '@ngrx/signals';
import { lastValueFrom } from 'rxjs';

export const BETS_REFRESH_INTERVAL = Math.random() * 30000 + 30000; // Random interval between 30s and 60s to prevent thundering herd on backend

@Injectable({
  providedIn: 'root',
})
export class SignalStoreBetsService {
  private readonly http = inject(HttpClient);
  public getBets(): Promise<PagedResponse<Bet>> {
    return lastValueFrom(this.http.get<PagedResponse<Bet>>(API.BETS.GET_ALL(0, 200)));
  }
}

export function withBetsFeature() {
  return signalStoreFeature(
    withState({
      bets: [] as Bet[],
      betsInitiallyLoaded: false,
    }),

    withComputed(({ bets, betsInitiallyLoaded }) => ({
      betsLoaded: computed(() => betsInitiallyLoaded()),
      allBets: computed(() => bets()),
      // betForMatch: (matchId: string = '') =>
      //   computed<Bet | undefined>(() => bets().find((b) => b.matchId === matchId)),
    })),

    withMethods((store) => {
      const service = inject(SignalStoreBetsService);

      return {
        async loadBets() {
          try {
            const result = await service.getBets();
            const bets = Array.isArray(result?.content) ? result.content : [];
            patchState(store, { bets, betsInitiallyLoaded: true });
          } catch (error) {
            // On error, keep last known state — prevents false "no bets" signals
            console.error('Failed to refresh bets:', error);
          }
        },

        betForMatch(matchId: string): Bet | undefined {
          console.log(
            'Finding bet for matchId:',
            matchId,
            store.allBets().find((b) => b.matchId === matchId),
          );
          return store.allBets().find((b) => b.matchId === matchId);
        },
      };
    }),
  );
}
