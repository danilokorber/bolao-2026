import { inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { OAuthEvent, OAuthService } from 'angular-oauth2-oidc';
import { AUTH_CONFIG } from '../config/auth.config';
import { AuthProvider } from '../enums/auth-providers';
import { OAuthEventType } from '../enums/o-auth-event-type';
import { HttpClient } from '@angular/common/http';
import { API } from '@api/api';
import { AppUser } from '@interfaces/app-user.interface';
import { firstValueFrom, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  protected readonly oAuthService = inject(OAuthService);
  protected readonly router = inject(Router);
  private readonly httpClient = inject(HttpClient);
  private initialized = false;

  private initialize(): void {
    if (this.initialized) return;
    this.initialized = true;
    this.oAuthService.configure(AUTH_CONFIG);
    this.oAuthService.events.subscribe((event: OAuthEvent) => {
      switch (event.type) {
        case OAuthEventType.DISCOVERY_DOCUMENT_LOADED:
        case OAuthEventType.TOKEN_REFRESHED:
        case OAuthEventType.SILENTLY_REFRESHED:
        case OAuthEventType.SESSION_UNCHANGED:
        case OAuthEventType.POPUP_CLOSED:
        case OAuthEventType.POPUP_BLOCKED:
          break;
        case OAuthEventType.TOKEN_RECEIVED:
        case OAuthEventType.SESSION_CHANGED:
          this.oAuthService.loadUserProfile();
          break;
        case OAuthEventType.USER_PROFILE_LOADED:
          this.router.navigate(['/post-login']);
          break;
        case OAuthEventType.JWKS_LOAD_ERROR:
        case OAuthEventType.INVALID_NONCE_IN_STATE:
        case OAuthEventType.DISCOVERY_DOCUMENT_LOAD_ERROR:
        case OAuthEventType.DISCOVERY_DOCUMENT_VALIDATION_ERROR:
        case OAuthEventType.USER_PROFILE_LOAD_ERROR:
        case OAuthEventType.TOKEN_ERROR:
        case OAuthEventType.CODE_ERROR:
        case OAuthEventType.TOKEN_REFRESH_ERROR:
        case OAuthEventType.SILENT_REFRESH_TIMEOUT:
        case OAuthEventType.SILENT_REFRESH_ERROR:
          console.warn('Silent refresh failed, attempting manual refresh');
          this.oAuthService.refreshToken();
          break;
        case OAuthEventType.TOKEN_VALIDATION_ERROR:
        case OAuthEventType.TOKEN_EXPIRES:
        case OAuthEventType.SESSION_ERROR:
        case OAuthEventType.SESSION_TERMINATED:
          this.router.navigate(['/logout']);
          break;
        case OAuthEventType.LOGOUT:
        case OAuthEventType.TOKEN_REVOKE_ERROR:
          this.router.navigate(['/logged-out']);
          break;
        default:
      }
    });
  }

  /** Process the OAuth callback if a code is present in the URL. */
  handleCallback(): void {
    this.initialize();
    this.oAuthService.loadDiscoveryDocumentAndTryLogin().then(() => {
      if (this.oAuthService.hasValidAccessToken()) {
        this.router.navigate(['/post-login']);
      }
    });
  }

  login(provider: AuthProvider): void {
    this.initialize();
    this.oAuthService.loadDiscoveryDocument().then(() => {
      this.oAuthService.initCodeFlow('', { kc_idp_hint: provider });
    });
  }

  logout(): void {
    const idToken = this.oAuthService.getIdToken();

    if (idToken) {
      this.oAuthService.logOut({
        id_token_hint: idToken,
      });
    } else {
      console.error('No ID token available for logout');
      this.oAuthService.logOut(); // Fallback without id_token_hint
    }
  }

  // NOTE: These accessors must read the OAuth state freshly on every call.
  // They wrap non-reactive `oAuthService` methods, so they MUST NOT be wrapped
  // in `computed()`: a computed with no signal dependencies evaluates once and
  // caches its value forever, which previously left guards reading a stale
  // "not logged in" result and caused an infinite /login redirect loop.
  userinfo = () => {
    return this.oAuthService.getIdentityClaims();
  };

  pictureUrl = () => {
    const claims = this.oAuthService.getIdentityClaims();
    const picture = claims && claims['picture'] ? claims['picture'] : undefined;
    return picture ? picture : 'platypus_clear.png'; // TODO: Replace with actual default avatar if needed
  };

  currentUser = () => {
    const claims = this.oAuthService.getIdentityClaims();
    return claims ? claims['sub'] : null;
  };

  isLoggedIn = () => {
    return (
      this.oAuthService.hasValidAccessToken() && this.oAuthService.getIdentityClaims() !== undefined
    );
  };

  isNotLoggedIn = () => {
    return !this.isLoggedIn();
  };

  token = () => {
    return this.oAuthService.getIdToken();
  };
}
