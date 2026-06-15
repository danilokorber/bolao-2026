import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { API } from '@api/api';

export interface FavoriteToggleResponse {
  userId: string;
  favoriteUserId: string;
  isFavorite: boolean;
}

export interface FavoriteToggleRequest {
  favoriteUserId: string;
}

@Injectable({
  providedIn: 'root',
})
export class UserFavoriteService {
  private readonly http = inject(HttpClient);

  /**
   * Toggle the favorite status of a user.
   * @param favoriteUserId The ID of the user to toggle as favorite
   * @returns Observable with the new favorite status
   */
  toggleFavorite(favoriteUserId: string) {
    const body: FavoriteToggleRequest = { favoriteUserId };
    return this.http.post<FavoriteToggleResponse>(
      API.FAVORITES.TOGGLE_FAVORITE(),
      body
    );
  }
}
