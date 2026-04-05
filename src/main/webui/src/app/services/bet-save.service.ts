import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap, finalize } from 'rxjs';
import { SAVE_FEEDBACK_DURATION_MS } from '@utils/constants';

export interface SaveState {
  saving: boolean;
  saved: boolean;
}

@Injectable({ providedIn: 'root' })
export class BetSaveService {
  private readonly http = inject(HttpClient);

  /**
   * Posts a bet payload to the given URL and manages saving/saved feedback
   * on the provided state object (or component fields via callbacks).
   */
  save<TResponse>(url: string, body: unknown, state: SaveState): Observable<TResponse> {
    state.saving = true;
    state.saved = false;

    return this.http.post<TResponse>(url, body).pipe(
      tap(() => {
        state.saved = true;
        setTimeout(() => (state.saved = false), SAVE_FEEDBACK_DURATION_MS);
      }),
      finalize(() => (state.saving = false)),
    );
  }
}
