import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { API } from '@api/api';

export interface FavoriteToggleResponse {
  isFavorite: boolean;
}

@Injectable({
  providedIn: 'root',
})
export class UserFavoriteService {
  private readonly http = inject(HttpClient);

  /**
   * Toggle the favorite status of a user.
   * @param userId The ID of the user to toggle as favorite
   * @returns Observable with the new favorite status
   */
  toggleFavorite(userId: string) {
    return this.http.post<FavoriteToggleResponse>(
      API.USERS.TOGGLE_FAVORITE(userId),
      {}
    );
  }
}
