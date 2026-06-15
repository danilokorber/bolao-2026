function buildPageParams(page?: number, size?: number, prefix = '?'): string {
  const params: string[] = [];
  if (page !== undefined) params.push(`page=${page}`);
  if (size !== undefined) params.push(`size=${size}`);
  return params.length ? `${prefix}${params.join('&')}` : '';
}

export const API = {
  USERS: {
    GET_ALL: (page?: number, size?: number) => `/api/v1/users${buildPageParams(page, size)}`,
    GET_BY_ID: (id: string) => `/api/v1/users/id/${id}`,
    GET_BY_KEYCLOAK_ID: (keycloakId: string) => `/api/v1/users/keycloak/${keycloakId}`,
    GET_BY_EMAIL: (email: string) => `/api/v1/users/email/${email}`,
    GET_ACTIVE: () => `/api/v1/users/active`,
    CREATE: () => `/api/v1/users`,
    UPDATE: (id: string) => `/api/v1/users/id/${id}`,
    DELETE: (id: string) => `/api/v1/users/id/${id}`,
    TOGGLE_FAVORITE: (userId: string) => `/api/v1/users/${userId}/toggle-favorite`,
  },

  MATCHES: {
    GET_ALL: (userId?: string, page?: number, size?: number) => {
      const params: string[] = [];
      if (userId) params.push(`userId=${userId}`);
      if (page !== undefined) params.push(`page=${page}`);
      if (size !== undefined) params.push(`size=${size}`);
      return `/api/v1/matches${params.length ? '?' + params.join('&') : ''}`;
    },
    GET_BY_ID: (id: string, userId?: string) =>
      `/api/v1/matches/id/${id}${userId ? '?userId=' + userId : ''}`,
    GET_BY_STAGE: (stage: string) => `/api/v1/matches/stage/${stage}`,
    GET_BY_STATUS: (status: string) => `/api/v1/matches/status/${status}`,
    GET_BY_TEAM: (teamId: string) => `/api/v1/matches/team/id/${teamId}`,
    GET_UPCOMING: (next: number = 128, userId?: string) =>
      `/api/v1/matches/upcoming?next=${next}${userId ? '&userId=' + userId : ''}`,
    GET_BY_DATE_RANGE: (start: string, end: string) =>
      `/api/v1/matches/date-range?start=${start}&end=${end}`,
    CREATE: () => `/api/v1/matches`,
    UPDATE: (id: string) => `/api/v1/matches/id/${id}`,
    DELETE: (id: string) => `/api/v1/matches/id/${id}`,
  },

  MATCHES_V2: {
    GET_ALL: () => `/api/v2/matches`,
  },

  RANKING: {
    GET_ALL: () => `/api/v1/ranking`,
    GET_HISTORY: () => `/api/v1/ranking/history`,
    GET_BY_POOL: (poolId: string) => `/api/v1/ranking/pool/${poolId}`,
    GET_HISTORY_BY_POOL: (poolId: string) => `/api/v1/ranking/pool/${poolId}/history`,
  },

  BETS: {
    GET_ALL: (page?: number, size?: number) => `/api/v1/bets${buildPageParams(page, size)}`,
    GET_BY_ID: (id: string) => `/api/v1/bets/id/${id}`,
    GET_BY_USER: (userId: string) => `/api/v1/bets/user/id/${userId}`,
    GET_BY_MATCH: (matchId: string) => `/api/v1/bets/match/id/${matchId}`,
    GET_BY_USER_AND_MATCH: (userId: string, matchId: string) =>
      `/api/v1/bets/user/id/${userId}/match/id/${matchId}`,
    GET_LEADERBOARD: (limit: number = 10) => `/api/v1/bets/leaderboard?limit=${limit}`,
    GET_TOTAL_POINTS: (userId: string) => `/api/v1/bets/user/id/${userId}/total-points`,
    SAVE: () => `/api/v1/bets`,
    DELETE: (id: string) => `/api/v1/bets/id/${id}`,
  },

  CHAMPION_BETS: {
    GET_ALL: (page?: number, size?: number) =>
      `/api/v1/champion-bets${buildPageParams(page, size)}`,
    GET_BY_ID: (id: string) => `/api/v1/champion-bets/id/${id}`,
    GET_BY_USER: (userId: string) => `/api/v1/champion-bets/user/id/${userId}`,
    GET_DEADLINE: () => `/api/v1/champion-bets/deadline`,
    COUNT_BY_CHAMPION: (teamId: string) => `/api/v1/champion-bets/stats/champion/id/${teamId}`,
    COUNT_BY_RUNNER_UP: (teamId: string) => `/api/v1/champion-bets/stats/runner-up/id/${teamId}`,
    SAVE: () => `/api/v1/champion-bets`,
    DELETE: (id: string) => `/api/v1/champion-bets/id/${id}`,
  },

  GROUP_WINNER_BETS: {
    GET_ALL: (page?: number, size?: number) =>
      `/api/v1/group-winner-bets${buildPageParams(page, size)}`,
    GET_BY_ID: (id: string) => `/api/v1/group-winner-bets/id/${id}`,
    GET_BY_USER: (userId: string) => `/api/v1/group-winner-bets/user/id/${userId}`,
    GET_BY_GROUP: (groupName: string) => `/api/v1/group-winner-bets/group/${groupName}`,
    GET_DEADLINES: () => `/api/v1/group-winner-bets/deadlines`,
    GET_BY_USER_AND_GROUP: (userId: string, groupName: string) =>
      `/api/v1/group-winner-bets/user/id/${userId}/group/${groupName}`,
    SAVE: () => `/api/v1/group-winner-bets`,
    DELETE: (id: string) => `/api/v1/group-winner-bets/id/${id}`,
  },

  PAYMENTS: {
    GET_ALL: (page?: number, size?: number) => `/api/v1/payments${buildPageParams(page, size)}`,
    GET_BY_ID: (id: string) => `/api/v1/payments/id/${id}`,
    GET_BY_USER: (userId: string) => `/api/v1/payments/user/id/${userId}`,
    GET_BY_POOL: (poolId: string) => `/api/v1/payments/pool/id/${poolId}`,
    GET_BY_USER_AND_POOL: (userId: string, poolId: string) =>
      `/api/v1/payments/user/id/${userId}/pool/id/${poolId}`,
    GET_BY_STATUS: (status: string) => `/api/v1/payments/status/${status}`,
    GET_BY_TRANSACTION_ID: (transactionId: string) =>
      `/api/v1/payments/transaction/${transactionId}`,
    GET_PENDING_BY_POOL: (poolId: string) => `/api/v1/payments/pool/id/${poolId}/pending`,
    CREATE: () => `/api/v1/payments`,
    UPDATE: (id: string) => `/api/v1/payments/id/${id}`,
    DELETE: (id: string) => `/api/v1/payments/id/${id}`,
  },

  POOLS: {
    GET_ALL: () => `/api/v1/pools`,
    GET_BY_ID: (id: string) => `/api/v1/pools/id/${id}`,
    GET_BY_INVITE_CODE: (inviteCode: string) => `/api/v1/pools/invite-code/${inviteCode}`,
    GET_ACTIVE: () => `/api/v1/pools/active`,
    GET_RECENT: () => `/api/v1/pools/recent`,
    CREATE: () => `/api/v1/pools`,
    UPDATE: (id: string) => `/api/v1/pools/id/${id}`,
    DELETE: (id: string) => `/api/v1/pools/id/${id}`,
  },

  TEAMS: {
    GET_ALL: () => `/api/v1/teams`,
    GET_BY_ID: (id: string) => `/api/v1/teams/id/${id}`,
    GET_BY_FIFA_CODE: (fifaCode: string) => `/api/v1/teams/fifa-code/${fifaCode}`,
    GET_BY_GROUP: (groupName: string) => `/api/v1/teams/group/${groupName}`,
    CREATE: () => `/api/v1/teams`,
    UPDATE: (id: string) => `/api/v1/teams/id/${id}`,
    DELETE: (id: string) => `/api/v1/teams/id/${id}`,
  },

  USER_POOLS: {
    GET_ALL: (page?: number, size?: number) => `/api/v1/user-pools${buildPageParams(page, size)}`,
    GET_BY_ID: (id: string) => `/api/v1/user-pools/id/${id}`,
    GET_BY_USER: (userId: string) => `/api/v1/user-pools/user/id/${userId}`,
    GET_BY_POOL: (poolId: string) => `/api/v1/user-pools/pool/id/${poolId}`,
    GET_BY_USER_AND_POOL: (userId: string, poolId: string) =>
      `/api/v1/user-pools/user/id/${userId}/pool/id/${poolId}`,
    GET_BY_USER_AND_STATUS: (userId: string, status: string) =>
      `/api/v1/user-pools/user/id/${userId}/status/${status}`,
    GET_BY_POOL_AND_STATUS: (poolId: string, status: string) =>
      `/api/v1/user-pools/pool/id/${poolId}/status/${status}`,
    COUNT_ACTIVE_MEMBERS: (poolId: string) => `/api/v1/user-pools/pool/id/${poolId}/members/count`,
    CREATE: () => `/api/v1/user-pools`,
    UPDATE: (id: string) => `/api/v1/user-pools/id/${id}`,
    DELETE: (id: string) => `/api/v1/user-pools/id/${id}`,
  },

  NOTIFICATIONS: {
    GET_PREFERENCES: () => `/api/v1/notifications/preferences`,
    UPDATE_PREFERENCES: () => `/api/v1/notifications/preferences`,
    GET_PUSH_PUBLIC_KEY: () => `/api/v1/notifications/push/public-key`,
    SUBSCRIBE: () => `/api/v1/notifications/push/subscriptions`,
    UNSUBSCRIBE: (endpoint: string) =>
      `/api/v1/notifications/push/subscriptions?endpoint=${encodeURIComponent(endpoint)}`,
  },
};
