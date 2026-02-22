import { computed, inject, Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { OAuthEvent, OAuthService } from 'angular-oauth2-oidc';
import { AUTH_CONFIG } from '../config/auth.config';
import { OAuthEventType } from '../enums/o-auth-event-type';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  protected readonly oAuthService = inject(OAuthService);
  protected readonly router = inject(Router);

  login(): void {
    this.oAuthService.configure(AUTH_CONFIG);
    this.oAuthService.loadDiscoveryDocumentAndLogin();

    this.oAuthService.events.pipe().subscribe((event: OAuthEvent) => {
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
          break; // Don't immediately logout
        case OAuthEventType.TOKEN_VALIDATION_ERROR:
        case OAuthEventType.INVALID_NONCE_IN_STATE:
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

    if (this.oAuthService.hasValidAccessToken()) {
      this.router.navigate(['/post-login']);
    }
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

  userinfo = computed(() => {
    return this.oAuthService.getIdentityClaims();
  });

  pictureUrl = computed(() => {
    const claims = this.oAuthService.getIdentityClaims();
    const picture = claims && claims['picture'] ? claims['picture'] : undefined;
    return picture ? picture : 'platypus_clear.png'; // TODO: Replace with actual default avatar if needed
  });

  currentUser = computed(() => {
    const claims = this.oAuthService.getIdentityClaims();
    return claims ? claims['sub'] : null;
  });

  isLoggedIn = computed(() => {
    return (
      this.oAuthService.hasValidAccessToken() && this.oAuthService.getIdentityClaims() !== undefined
    );
  });

  isNotLoggedIn = computed(() => {
    return !this.oAuthService.hasValidAccessToken();
  });

  token = computed(() => {
    return this.oAuthService.getIdToken();
  });
}
