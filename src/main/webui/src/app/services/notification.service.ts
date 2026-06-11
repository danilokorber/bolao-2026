import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { SwPush } from '@angular/service-worker';
import { API } from '@api/api';
import { NotificationPreference, PushPublicKey } from '@interfaces/index';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class NotificationService {
  private readonly http = inject(HttpClient);
  private readonly swPush = inject(SwPush);

  getPreferences() {
    return this.http.get<NotificationPreference>(API.NOTIFICATIONS.GET_PREFERENCES());
  }

  updatePreferences(payload: NotificationPreference) {
    return this.http.put<NotificationPreference>(API.NOTIFICATIONS.UPDATE_PREFERENCES(), payload);
  }

  async isSubscribed(): Promise<boolean> {
    if (!this.swPush.isEnabled) {
      return false;
    }
    const subscription = await firstValueFrom(this.swPush.subscription);
    return !!subscription;
  }

  async subscribe(): Promise<boolean> {
    if (!this.swPush.isEnabled) {
      return false;
    }
    const pushInfo = await firstValueFrom(this.http.get<PushPublicKey>(API.NOTIFICATIONS.GET_PUSH_PUBLIC_KEY()));
    if (!pushInfo.enabled || !pushInfo.publicKey) {
      return false;
    }
    const subscription = await this.swPush.requestSubscription({
      serverPublicKey: pushInfo.publicKey,
    });
    const keys = subscription.toJSON().keys;
    await firstValueFrom(
      this.http.post(API.NOTIFICATIONS.SUBSCRIBE(), {
        endpoint: subscription.endpoint,
        p256dhKey: keys?.['p256dh'],
        authKey: keys?.['auth'],
        userAgent: navigator.userAgent,
      })
    );
    return true;
  }

  async unsubscribe(): Promise<void> {
    if (!this.swPush.isEnabled) {
      return;
    }
    const subscription = await firstValueFrom(this.swPush.subscription);
    if (!subscription) {
      return;
    }
    await firstValueFrom(this.http.delete(API.NOTIFICATIONS.UNSUBSCRIBE(subscription.endpoint)));
    await subscription.unsubscribe();
  }
}
