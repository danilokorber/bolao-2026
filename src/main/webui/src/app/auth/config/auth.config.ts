import { AuthConfig, OAuthModuleConfig } from 'angular-oauth2-oidc';

export const AUTH_DEFAULTS = {
  URL: 'https://auth.easyware.io',
  REALM: 'bolao',
  REDIRECT_AFTER_LOGIN: '/login',
  REDIRECT_AFTER_LOGOUT: '/post-logout',
};

export const KEYCLOAK = {
  CLIENT_ID: 'f0759f36-6cdc-4601-835b-8701316f05ab', // frontend
  URL: AUTH_DEFAULTS.URL,
  REALM: AUTH_DEFAULTS.REALM,
  WELL_KNOWN: `${AUTH_DEFAULTS.URL}/realms/${AUTH_DEFAULTS.REALM}/.well-known/openid-configuration`,
  REVOKE: `${AUTH_DEFAULTS.URL}/realms/${AUTH_DEFAULTS.REALM}/protocol/openid-connect/revoke`,
  TOKEN: `${AUTH_DEFAULTS.URL}/realms/${AUTH_DEFAULTS.REALM}/protocol/openid-connect/token`,
  USERINFO: `${AUTH_DEFAULTS.URL}/realms/${AUTH_DEFAULTS.REALM}/protocol/openid-connect/userinfo`,
};

// Base configurations
export const AUTH_CONFIG: AuthConfig = {
  issuer: `${KEYCLOAK.URL}/realms/${KEYCLOAK.REALM}`,
  clientId: KEYCLOAK.CLIENT_ID,
  redirectUri: window.location.origin + AUTH_DEFAULTS.REDIRECT_AFTER_LOGIN,
  postLogoutRedirectUri: window.location.origin + AUTH_DEFAULTS.REDIRECT_AFTER_LOGOUT,

  responseType: 'code',
  scope: 'openid profile email roles address phone',

  // useSilentRefresh: false,
  // silentRefreshRedirectUri: window.location.origin + '/silent-refresh.html',
  // silentRefreshTimeout: 300_000,

  // timeoutFactor: 0.75, // Refresh tokens at 75% of their lifetime
  // sessionChecksEnabled: false,
  // clearHashAfterLogin: true,

  requireHttps: true, // Enforce HTTPS in production
  strictDiscoveryDocumentValidation: false,
  checkOrigin: false,

  customQueryParams: {
    kc_idp_hint: 'google',
  },

  tokenEndpoint: KEYCLOAK.TOKEN,
  userinfoEndpoint: KEYCLOAK.USERINFO,

  // Add client authentication for public clients
  skipIssuerCheck: false,
  oidc: true, // Enable OIDC mode
};

export const AUTH_MODULE_CONFIG: OAuthModuleConfig = {
  resourceServer: {
    sendAccessToken: true,
    allowedUrls: ['/api/v3', '/api'],
  },
};
