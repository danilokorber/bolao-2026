import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { API } from '@api/api';
import { AuthService } from '@auth/services/auth.service';
import { RouteVisitRequest } from '@interfaces/index';
import { detectBrowser, UserAgentDataLike } from '@utils/browser-info';

const SESSION_ID_STORAGE_KEY = 'bolao_session_id';

/**
 * Sends a fire-and-forget telemetry POST on each authenticated route change.
 * All collected data is publicly available without special user consent
 * (no IP address or geolocation). Failures are swallowed so navigation is
 * never disrupted.
 */
@Injectable({ providedIn: 'root' })
export class RouteTrackingService {
  private readonly http = inject(HttpClient);
  private readonly auth = inject(AuthService);

  track(path: string): void {
    if (!this.auth.isLoggedIn()) {
      return;
    }

    this.http.post<void>(API.ROUTE_VISITS.TRACK(), this.buildPayload(path)).subscribe({
      error: () => {
        // Best-effort telemetry: ignore errors.
      },
    });
  }

  private buildPayload(path: string): RouteVisitRequest {
    const uaData = (navigator as Navigator & { userAgentData?: UserAgentDataLike }).userAgentData;
    const { browserName, browserVersion, osName } = detectBrowser(navigator.userAgent, uaData);

    return {
      sessionId: this.sessionId(),
      path,
      screenWidth: window.screen.width,
      screenHeight: window.screen.height,
      viewportWidth: window.innerWidth,
      viewportHeight: window.innerHeight,
      devicePixelRatio: window.devicePixelRatio,
      browserName,
      browserVersion,
      osName,
      language: navigator.language,
      timezone: this.timezone(),
      referrer: document.referrer || undefined,
      userAgent: navigator.userAgent,
    };
  }

  private sessionId(): string {
    let id = sessionStorage.getItem(SESSION_ID_STORAGE_KEY);
    if (!id) {
      id = crypto.randomUUID();
      sessionStorage.setItem(SESSION_ID_STORAGE_KEY, id);
    }
    return id;
  }

  private timezone(): string | undefined {
    try {
      return Intl.DateTimeFormat().resolvedOptions().timeZone;
    } catch {
      return undefined;
    }
  }
}
