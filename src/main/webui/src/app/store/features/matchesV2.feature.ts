import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable } from '@angular/core';
import { API } from '@api/api';
import { MatchStatus, MatchV2 } from '@interfaces/index';
import {
  patchState,
  signalStoreFeature,
  withComputed,
  withMethods,
  withState,
} from '@ngrx/signals';
import { lastValueFrom } from 'rxjs';
import { utcDate } from '../../utils/date-utils';

export const MATCHESV2_REFRESH_INTERVAL = Math.random() * 30000 + 30000; // Random interval between 30s and 60s to prevent thundering herd on backend

@Injectable({
  providedIn: 'root',
})
export class SignalStoreMatchesV2Service {
  private readonly http = inject(HttpClient);
  public getMatches(): Promise<MatchV2[]> {
    return lastValueFrom(this.http.get<MatchV2[]>(API.MATCHES_V2.GET_ALL()));
  }
  public postBet(
    userId: string,
    matchId: string,
    homeGoalsBet: number,
    awayGoalsBet: number,
  ): Promise<void> {
    return lastValueFrom(
      this.http.post<void>(API.BETS.SAVE(), {
        userId,
        matchId,
        homeGoalsBet,
        awayGoalsBet,
      }),
    );
  }
}

export function withMatchesV2Feature() {
  return signalStoreFeature(
    withState({
      matchesV2: [] as MatchV2[],
      matchesV2InitiallyLoaded: false,
    }),

    withComputed(({ matchesV2, matchesV2InitiallyLoaded }) => ({
      matchesV2Loaded: computed<boolean>(() => matchesV2InitiallyLoaded()),
      allMatchesV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return [...list].sort(
          (a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime(),
        );
      }),
      pastMatchesV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return list
          .filter((m) => m.status == MatchStatus.FINISHED)
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      futureMatchesV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return list
          .filter((m) => m.status == MatchStatus.SCHEDULED)
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      liveMatchesV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return list
          .filter((m) => m.status == MatchStatus.LIVE)
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      last5MatchesV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return list
          .filter((m) => m.status == MatchStatus.FINISHED)
          .sort((a, b) => utcDate(b.matchDatetime).getTime() - utcDate(a.matchDatetime).getTime())
          .slice(0, 5);
      }),
      upcomingMatchesV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return list
          .filter(
            (m) => m.status == MatchStatus.SCHEDULED && new Date(m.matchDatetime) > new Date(),
          )
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      upcomingMatches36hV2: computed<MatchV2[]>(() => {
        const list = Array.isArray(matchesV2()) ? matchesV2() : [];
        return list
          .filter(
            (m) =>
              m.status == MatchStatus.SCHEDULED &&
              new Date(m.matchDatetime) > new Date() &&
              new Date(m.matchDatetime) <= new Date(Date.now() + 36 * 60 * 60 * 1000),
          )
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
    })),

    withMethods((store) => {
      const service = inject(SignalStoreMatchesV2Service);

      return {
        async loadMatchesV2() {
          try {
            const matchesV2 = await service.getMatches();
            patchState(store, { matchesV2, matchesV2InitiallyLoaded: true });
          } catch (error) {
            // On error, keep last known state — prevents false "no matches" signals
            console.error('Failed to refresh matches:', error);
          }
        },

        async placeBet(
          userId: string,
          matchId: string,
          homeGoalsBet: number,
          awayGoalsBet: number,
        ) {
          // This method is just a placeholder to be called from the bet form component — actual implementation is in the component for now
          console.log('Placing bet for match', matchId, 'with', homeGoalsBet, awayGoalsBet);
          const bet = await service.postBet(userId, matchId, homeGoalsBet, awayGoalsBet);
          console.log('Bet placed successfully');
          this.loadMatchesV2(); // Refresh matches to get the updated bet — can be optimized by just updating the relevant match in the state instead of reloading everything
        },
      };
    }),
  );
}
