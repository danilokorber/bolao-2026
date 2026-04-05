import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { API } from '@api/api';
import { AuthService } from '@auth/services/auth.service';
import { AppUser } from '@interfaces/index';
import { lastValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class SignalStoreService {
  private readonly http = inject(HttpClient);
  private readonly auth = inject(AuthService);

  public setOrGetProfile(): Promise<AppUser> {
    const currentAppUser: AppUser = {
      keycloakId: this.auth.currentUser() || '',
      name: this.auth.userinfo()!['name'],
      email: this.auth.userinfo()!['email'],
    };
    return lastValueFrom(this.http.post<AppUser>(API.USERS.CREATE(), currentAppUser));
  }
}
