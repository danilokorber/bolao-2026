import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { API } from '@api/api';
import { AuthService } from '@auth/services/auth.service';
import { AppUser, UserPool } from '@interfaces/index';
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

  public async getFirstActivePoolId(userId: string): Promise<string | undefined> {
    try {
      const pools = await lastValueFrom(
        this.http.get<UserPool[]>(API.USER_POOLS.GET_BY_USER_AND_STATUS(userId, 'ACTIVE'))
      );
      return pools.length > 0 ? pools[0].poolId : undefined;
    } catch {
      return undefined;
    }
  }
}
