# Bolão da Copa 2026 — Project Analysis Report

> Generated on 2026-04-26

---

## 1. Project Overview

A **FIFA World Cup 2026 betting pool ("Bolão")** web application where users predict match scores, group winners, and tournament champions across shared pools — each pool with its own independent ranking.

| Attribute | Value |
|-----------|-------|
| **Backend** | Quarkus 3.34.1 / Java 21, Hibernate Panache, PostgreSQL |
| **Frontend** | Angular 21.1.5 (standalone, zoneless, signal-based), Tailwind CSS v4 |
| **Auth** | Keycloak via OAuth2 PKCE flow (Google, Facebook, Twitter, Microsoft) |
| **i18n** | Portuguese, English, German (Transloco) |
| **Expected users** | < 100 |
| **Codebase** | 73 Java files · 85 TypeScript files · 9 Flyway migrations · 0 tests |

---

## 2. Architecture Summary

### Backend (`src/main/java/io/easyware/bolao/`)

| Layer | Count | Description |
|-------|-------|-------------|
| **Entities** | 9 | JPA entities with Panache (AppUser, Team, Match, Pool, UserPool, Payment, Bet, ChampionBet, GroupWinnerBet) |
| **Repositories** | 9 | `PanacheRepositoryBase<Entity, UUID>` with custom queries |
| **Services** | 11 | Business logic (`@ApplicationScoped`, `@Transactional`) |
| **Resources** | 11 | JAX-RS REST endpoints (`/api/v1/...`) |
| **DTOs** | 14 | Request and response data transfer objects |
| **Mappers** | 9 | MapStruct entity ↔ DTO mappers |
| **Enums** | 7 | Currency, GroupName, MatchStage, MatchStatus, PaymentMethod, PaymentStatus, UserPoolStatus |
| **Schedules** | 1 | MatchUpdateScheduler (football-data.org polling — stubbed) |
| **Utilities** | 1 | UUIDv7Generator (time-ordered UUIDs) |

### Frontend (`src/main/webui/src/app/`)

| Layer | Count | Description |
|-------|-------|-------------|
| **Pages** | 8 | Dashboard, Matches, Match Detail, Ranking, User Bets, Account, Group Winner Bets, Champion Bet |
| **Components** | 24 | Match cards, bet forms, team selects, charts, dialogs, indicators |
| **Services** | 5 | BetSaveService, ScoreService, StageService, TeamService, SignalStoreService |
| **Layouts** | 3 | NavigationLayout, CleanLayout, FullPageLayout |
| **Store** | 1 | NGRX Signals (current user state) |
| **Pipes** | 1 | TeamNamePipe |
| **Directives** | 1 | FlagFallbackDirective |

---

## 3. What's Working ✅

### 3.1 Data Model — Complete

All 9 entities match the schema requirements with proper constraints:

- **Unique constraints** enforced at DB level: (user_id, match_id) on bet, (user_id) on champion_bet, (user_id, group_name) on group_winner_bet, (user_id, pool_id) on user_pool
- **Indexes** on all FK columns and frequently queried fields
- **UUIDv7** for sortable, time-ordered primary keys
- **Cascade deletes** on dependent entities (UserPool, Payment, Bet)

### 3.2 REST API — 11 Fully-Implemented Resources

| Resource | Path | Key Operations |
|----------|------|----------------|
| AppUser | `/v1/users` | CRUD + find by keycloak ID / email |
| Team | `/v1/teams` | CRUD + find by FIFA code / group |
| Match | `/v1/matches` | CRUD + filter by stage/status/team/upcoming + user bet inclusion |
| Pool | `/v1/pools` | CRUD + find by invite code |
| UserPool | `/v1/user-pools` | CRUD + member counting + status filtering |
| Payment | `/v1/payments` | CRUD + status workflow + pending-by-pool |
| Bet | `/v1/bets` | Upsert + leaderboard + total points |
| ChampionBet | `/v1/champion-bets` | Upsert + deadline check + team stats |
| GroupWinnerBet | `/v1/group-winner-bets` | Upsert + per-group deadlines |
| Score (Admin) | `/v1/admin/scores` | Calculate / recalculate points |
| Ranking | `/v1/ranking` | Global leaderboard + points history |

### 3.3 Betting System — Fully Functional

- **Match bets**: One bet per user per match, auto-locked when match starts
- **Group winner bets**: One per user per group (12 groups), locked when group's 2nd matchday starts
- **Champion bets**: One per user, locked when Round of 16 starts
- **Upsert pattern**: Single POST creates or updates — no separate PUT needed

### 3.4 Scoring Engine — `ScoreCalculationService`

Real-time scoring as matches progress:

| Bet Type | Points |
|----------|--------|
| Exact score | 10 |
| Correct goal difference | 5 |
| Correct result (winner) | 3 |
| Inverted score | 1 |
| Wrong prediction | −3 |
| Group 1st place correct | 5 |
| Group 2nd place correct | 3 |
| Both group places correct | +2 bonus (= 10 total) |
| Champion correct | 20 |
| Runner-up correct | 10 |
| Each semifinalist correct | 5 |

### 3.5 Authentication — Keycloak OIDC

- OAuth2 Authorization Code flow with PKCE
- Social login: Google, Facebook, Twitter, Microsoft
- Auto-create `AppUser` on first login
- Silent token refresh with fallback
- Route guards on all authenticated pages

### 3.6 Frontend UX

- **Modern Angular 21**: Standalone components, signals (`input()`, `output()`, `computed()`, `linkedSignal()`), `httpResource`, `@if`/`@for` control flow, zoneless
- **Responsive**: Tailwind CSS v4 with mobile-first breakpoints
- **Dark mode**: Toggle with localStorage persistence
- **i18n**: 3 languages with Transloco, persisted preference
- **Auto-save**: Debounced (300ms) bet saving with visual feedback
- **Charts**: Points progression and position history (ag-charts)

### 3.7 Database

- PostgreSQL with 9 Flyway migrations (2,157 lines of SQL)
- All 48 teams seeded with multilingual names and flag URLs
- All 104 World Cup 2026 matches seeded with schedule
- Mock data for testing (group results, knockout results, sample bets)

---

## 4. What's Missing 🔴

### 4.1 Backend — Critical Gaps

| # | Gap | Severity | Details |
|---|-----|----------|---------|
| 1 | **Pool-based rankings** | 🔴 Critical | Only a global ranking exists. Per-pool ranking (the core feature) is not implemented. Need `GET /v1/ranking/pool/{poolId}` filtered by ACTIVE user_pool status. |
| 2 | **Stage multipliers** | ✅ Done | Base points doubled (20/10/6/2/−6) and multiplied by stage: Group/R32=1×, R16=1.5×, QF=2×, SF/3rd/Final=3×. |
| 3 | **Round bonuses** | 🟡 High | "Best predictor of the round: +5 pts" and "Top 3 of the round: +2 pts" — not implemented. |
| 4 | **Recovery bonus** | 🟡 High | "Users scoring above pool average: +10 bonus pts for next phase" — not implemented. |
| 5 | **Football-data.org API** | 🟡 High | `MatchUpdateScheduler` runs every minute but REST client is stubbed — no live score ingestion. |
| 6 | **Security enforcement** | 🔴 Critical | `@Authenticated` and `@RolesAllowed` annotations are commented out. All endpoints are publicly accessible. |
| 7 | **Input validation** | ✅ Done | Bean Validation annotations on all request DTOs + `@Valid` on all POST/PUT endpoints + custom `ConstraintViolationExceptionMapper` returning structured JSON 400 errors. |
| 8 | **Pagination** | 🟡 Medium | List endpoints (`GET /v1/users`, `GET /v1/bets`) return all records with no pagination. |
| 9 | **Tests** | 🔴 Critical | Zero unit or integration tests. `src/test/` directory does not exist. |

### 4.2 Frontend — Critical Gaps

| # | Gap | Severity | Details |
|---|-----|----------|---------|
| 1 | **Pool management UI** | 🔴 Critical | No pages to create, join, list, or manage pools. Backend has the API, frontend doesn't use it. |
| 2 | **Payment tracking UI** | 🔴 Critical | No interface for users to view payment status or for admins to confirm payments. |
| 3 | **Admin dashboard** | 🔴 Critical | No admin-facing features whatsoever (user management, payment confirmation, pool oversight). |
| 4 | **Error handling** | 🔴 Critical | No HTTP interceptor, no toast/snackbar notifications. Errors only appear in browser console. |
| 5 | **Navigation sidebar** | 🟡 High | Sidebar has placeholder "Item 1/2/3" links — not wired to actual routes (Dashboard, Matches, Ranking, etc.). |
| 6 | **Form validation feedback** | 🟡 High | No visible error messages on invalid inputs. Users get no feedback on what went wrong. |
| 7 | **404/Error pages** | 🟡 Medium | No dedicated error or not-found pages. Catch-all redirects to `/login`. |
| 8 | **User profile editing** | 🟡 Medium | No way to change name/email from the frontend. |
| 9 | **Real-time updates** | 🟡 Medium | No WebSocket or polling for live match score changes. |
| 10 | **Tests** | 🔴 Critical | Zero unit, component, or E2E tests. |

---

## 5. Scoring Rules — Spec vs. Implementation

| Rule | Spec | Implemented? |
|------|------|:------------:|
| Exact score (group) | 5 pts | ⚠️ Returns 10 pts |
| Correct diff (group) | 3 pts | ⚠️ Returns 5 pts |
| Correct result (group) | 2 pts | ⚠️ Returns 3 pts |
| Wrong (group) | 0 pts | ⚠️ Returns −3 pts |
| Exact score (knockout) | 8 pts | ⚠️ Returns 10 pts |
| Correct qualifier only | 3 pts | ✅ |
| Stage multipliers | 1x / 1.5x / 2x / 3x | ✅ Applied (base doubled to keep integers) |
| Group winner 1st | +5 pts | ✅ |
| Group winner 2nd | +3 pts | ✅ |
| Both group winners | +10 pts (bonus) | ✅ (+2 bonus = 10) |
| Champion | +15 pts | ⚠️ Returns 20 pts |
| Runner-up | +10 pts | ✅ |
| Semifinalists | +8 pts each | ⚠️ Returns 5 pts each |
| Best predictor bonus | +5 pts | ❌ Not implemented |
| Top 3 of round | +2 pts | ❌ Not implemented |
| Recovery bonus | +10 pts next phase | ❌ Not implemented |

> **Note:** The point values in the implementation differ from the original spec in `WORLDCUP_POOL_CONTEXT.md`. The copilot instructions document shows the _implemented_ values (10/5/3/1/−3). This may be an intentional design evolution or a divergence that needs alignment.

---

## 6. Security Assessment

| Check | Status | Notes |
|-------|--------|-------|
| Keycloak OIDC configured | ✅ | Backend + frontend both configured |
| HTTPS enforced | ✅ | `requireHttps: true` in auth config |
| OAuth2 PKCE flow | ✅ | Prevents auth code interception |
| Endpoint protection | ❌ | `@Authenticated` annotations commented out |
| Role-based access | ❌ | No `@RolesAllowed` — admin endpoints accessible to all |
| Input validation | ❌ | No Bean Validation on request DTOs |
| CORS configuration | ⚠️ | Not explicitly configured (relies on Quarkus defaults) |
| Rate limiting | ❌ | No rate limiting on any endpoints |
| SQL injection | ✅ | Panache uses parameterized queries |
| XSS prevention | ⚠️ | No explicit input sanitization |

---

## 7. Database Migrations

| Version | Purpose | Lines |
|---------|---------|-------|
| V2026.0.0.0 | Schema creation (all 8 tables + constraints) | 233 |
| V2026.0.0.1 | Seed 48 teams + 104 matches | 805 |
| V2026.0.0.2 | Replace playoff placeholders with qualified teams | ~30 |
| V2026.0.0.3 | Anticipate all matches by 3 months (testing) | ~10 |
| V2026.0.0.4 | Mock group stage results (72 matches) | ~200 |
| V2026.0.0.5 | Mock bets for test user | ~100 |
| V2026.0.0.6 | Mock knockout results + bets | ~200 |
| V2026.0.0.7 | Additional bets for second test user | ~100 |
| V2026.0.0.8 | Allow negative bet points (−3) | ~5 |

> ⚠️ Migrations V3–V7 contain **mock/test data** and should be excluded from production deployments or moved to a dev-only profile.

---

## 8. Performance Considerations

### ✅ Good
- Indexes on all FK columns and frequently queried fields
- Lazy loading on `@ManyToOne` relationships
- Batch operations in score calculation
- `< 100 users` means most concerns are theoretical

### ⚠️ Could Improve
- No pagination on list endpoints (acceptable for <100 users, won't scale)
- Global ranking query uses subqueries — could use window functions
- No caching layer for immutable data (teams, match schedule)
- No client-side caching strategy (all data refetched on navigation)

---

## 9. Production Readiness Verdict

### Overall Maturity: **~70% — Solid MVP foundation, not production-ready**

The **core betting flow works end-to-end**: login → place match/group/champion bets → scores calculated → global ranking displayed. The architecture is clean and modern on both backend and frontend.

### 🔴 Must Fix Before Production

1. **Pool-based rankings** — The defining feature of the app
2. **Security enforcement** — Uncomment `@Authenticated`/`@RolesAllowed`
3. **Pool management UI** — Create/join/list pools in the frontend
4. **Payment tracking UI** — View and confirm payments
5. **Error handling** — HTTP interceptor + user-facing notifications
6. **Navigation sidebar** — Wire placeholder links to real routes
7. ~~**Stage multipliers**~~ — ✅ Done
8. **Remove test migrations** — Exclude mock data from production Flyway

### 🟡 Should Fix (High Priority)

1. Admin dashboard for pool/payment/user management
2. Form validation with visible error messages
3. Football-data.org integration for live score updates
4. Round bonuses and recovery bonus implementation
5. Align scoring point values with the spec (or update the spec)
6. Basic test coverage for scoring engine and bet services

### 🟢 Nice to Have

1. Real-time updates via WebSocket
2. Comprehensive test suite
3. Performance monitoring / error tracking (Sentry)
4. Offline support via Service Worker
5. Notifications (bet reminders, match results)
6. Statistics and analytics pages
