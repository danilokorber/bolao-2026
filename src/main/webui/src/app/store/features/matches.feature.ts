import { HttpClient } from '@angular/common/http';
import { computed, inject, Injectable, Signal } from '@angular/core';
import { API } from '@api/api';
import { AppUser } from '@interfaces/app-user.interface';
import { MatchStatus, PagedResponse } from '@interfaces/index';
import { Match } from '@interfaces/match.interface';
import {
  patchState,
  signalStoreFeature,
  withComputed,
  withMethods,
  withState,
} from '@ngrx/signals';
import { lastValueFrom } from 'rxjs';
import { utcDate } from '../../utils/date-utils';

export const MATCHES_REFRESH_INTERVAL = Math.random() * 30000 + 30000; // Random interval between 30s and 60s to prevent thundering herd on backend

@Injectable({
  providedIn: 'root',
})
export class SignalStoreMatchesService {
  private readonly http = inject(HttpClient);
  public getMatches(userId: string | undefined): Promise<PagedResponse<Match>> {
    return lastValueFrom(this.http.get<PagedResponse<Match>>(API.MATCHES.GET_ALL(userId, 0, 200)));
  }
}

export function withMatchesFeature() {
  return signalStoreFeature(
    withState({
      matches: [] as Match[],
      matchesInitiallyLoaded: false,
    }),

    withComputed(({ matches, matchesInitiallyLoaded }) => ({
      matchesLoaded: computed(() => matchesInitiallyLoaded()),
      allMatches: computed(() => {
        const list = Array.isArray(matches()) ? matches() : [];
        return [...list].sort(
          (a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime(),
        );
      }),
      pastMatches: computed(() => {
        const list = Array.isArray(matches()) ? matches() : [];
        return list
          .filter((m) => m.status == MatchStatus.FINISHED)
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      futureMatches: computed(() => {
        const list = Array.isArray(matches()) ? matches() : [];
        return list
          .filter((m) => m.status == MatchStatus.SCHEDULED)
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      liveMatches: computed(() => {
        const list = Array.isArray(matches()) ? matches() : [];
        return list
          .filter((m) => m.status == MatchStatus.LIVE)
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      upcomingMatches: computed(() => {
        const list = Array.isArray(matches()) ? matches() : [];
        return list
          .filter(
            (m) => m.status == MatchStatus.SCHEDULED && new Date(m.matchDatetime) > new Date(),
          )
          .sort((a, b) => utcDate(a.matchDatetime).getTime() - utcDate(b.matchDatetime).getTime());
      }),
      upcomingMatches36h: computed(() => {
        const list = Array.isArray(matches()) ? matches() : [];
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
      const service = inject(SignalStoreMatchesService);

      return {
        async loadMatches() {
          try {
            const userId = (store as unknown as { appuser: Signal<AppUser | undefined> }).appuser?.()?.id;
            const result = await service.getMatches(userId);
            const matches = Array.isArray(result?.content) ? result.content : [];
            patchState(store, { matches, matchesInitiallyLoaded: true });
            console.log('Matches refreshed:', matches);
          } catch (error) {
            // On error, keep last known state — prevents false "no matches" signals
            console.error('Failed to refresh matches:', error);
          }
        },
      };
    }),
  );
}
