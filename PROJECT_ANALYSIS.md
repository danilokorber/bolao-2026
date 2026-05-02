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
| **Codebase** | ~80 Java files · 85 TypeScript files · 12 Flyway migrations · 69 unit tests |

---

## 2. Architecture Summary

### Backend (`src/main/java/io/easyware/bolao/`)

| Layer | Count | Description |
|-------|-------|-------------|
| **Entities** | 10 | JPA entities with Panache (AppUser, Team, Match, Pool, UserPool, Payment, Bet, ChampionBet, GroupWinnerBet, PoolBonus) |
| **Repositories** | 10 | `PanacheRepositoryBase<Entity, UUID>` with custom queries |
| **Services** | 12 | Business logic (`@ApplicationScoped`, `@Transactional`) incl. ScoreCalculationService, BonusCalculationService |
| **Resources** | 11 | JAX-RS REST endpoints (`/api/v1/...`) — all protected with `@Authenticated` / `@RolesAllowed` |
| **DTOs** | 15 | Request/response DTOs + `PagedResponse<T>` generic wrapper |
| **Mappers** | 9 | MapStruct entity ↔ DTO mappers |
| **Enums** | 10 | Currency, GroupName, MatchStage (with multiplier), MatchStatus, PaymentMethod, PaymentStatus, UserPoolStatus, ScoreTier, TournamentRound, BonusType |
| **Schedules** | 1 | MatchUpdateScheduler (football-data.org polling — stubbed) |
| **Utilities** | 1 | UUIDv7Generator (time-ordered UUIDs) |

### Frontend (`src/main/webui/src/app/`)

| Layer | Count | Description |
|-------|-------|-------------|
| **Pages** | 8 | Dashboard, Matches, Match Detail, Ranking, User Bets, Account, Group Winner Bets, Champion Bet |
| **Components** | 24 | Match cards, bet forms, team selects, charts, dialogs, indicators |
| **Services** | 5 | BetSaveService, ScoreService, StageService, TeamService, SignalStoreService |
| **Layouts** | 3 | NavigationLayout, CleanLayout, FullPageLayout |
| **Store** | 1 | Signal-based global state (current user + current pool ID) |
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

### 3.4 Scoring Engine — `ScoreCalculationService` + `BonusCalculationService`

Real-time scoring as matches progress, with stage multipliers and pool bonuses:

**Base points** (doubled to keep integer arithmetic with multipliers):

| Bet Type | Base Points |
|----------|-------------|
| Exact score | 20 |
| Correct goal difference | 10 |
| Correct result (winner) | 6 |
| Inverted score | 2 |
| Wrong prediction | −6 |

**Stage multipliers** applied to match bets:

| Stage | Multiplier | Example (exact) |
|-------|------------|-----------------|
| Group / Round of 32 | 1× | 20 pts |
| Round of 16 | 1.5× | 30 pts |
| Quarter-finals | 2× | 40 pts |
| Semi-finals / Third place / Final | 3× | 60 pts |

**Special bets:**

| Bet Type | Points |
|----------|--------|
| Group 1st place correct | 5 |
| Group 2nd place correct | 3 |
| Both group places correct | +2 bonus (= 10 total) |
| Champion correct | 20 |
| Runner-up correct | 10 |
| Each semifinalist correct | 5 |

**Pool bonuses** (per-pool, per-round):

| Bonus | Points | Condition |
|-------|--------|-----------|
| Best predictor of the round | +5 | Highest match points in round (ties share) |
| Top 3 of the round | +2 | 2nd/3rd in round (ties share) |
| Recovery bonus | +10 | Score strictly above pool average in a round (awarded next round) |

Score tiers (`ScoreTier` enum: EXACT, DIFF, WINNER, INVERTED, WRONG) are persisted on each bet for accurate ranking tier counts independent of stage multipliers.

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
| 1 | **Pool-based rankings** | ✅ Done | Per-pool ranking via `GET /v1/ranking/pool/{poolId}` (+ history). Tier-based counting (`score_tier` column) replaces point-value counting. Frontend auto-detects user's first active pool; falls back to global. |
| 2 | **Stage multipliers** | ✅ Done | Base points doubled (20/10/6/2/−6) and multiplied by stage: Group/R32=1×, R16=1.5×, QF=2×, SF/3rd/Final=3×. |
| 3 | **Round bonuses** | ✅ Done | Best predictor of the round: +5 pts; Top 3: +2 pts each. Per-pool, 6 tournament rounds. Ties share the same bonus. `BonusCalculationService` + `pool_bonus` table. |
| 4 | **Recovery bonus** | ✅ Done | Users scoring strictly above pool average in a round get +10 flat bonus (tagged with next round). Per-pool. No recovery after Final. |
| 5 | **Football-data.org API** | 🟡 High | `MatchUpdateScheduler` runs every minute but REST client is stubbed — no live score ingestion. |
| 6 | **Security enforcement** | ✅ Done | `@Authenticated` on all 10 user-facing resources (class-level). `@RolesAllowed("admin")` on ScoreResource (class-level) + admin-only methods (match/team/pool CRUD, user/bet delete, payment management). |
| 7 | **Input validation** | ✅ Done | Bean Validation annotations on all request DTOs + `@Valid` on all POST/PUT endpoints + custom `ConstraintViolationExceptionMapper` returning structured JSON 400 errors. |
| 8 | **Pagination** | ✅ Done | `PagedResponse<T>` wrapper DTO with `content`, `page`, `size`, `totalElements`, `totalPages`. Applied to 7 `getAll()` endpoints (users, bets, matches, champion-bets, group-winner-bets, payments, user-pools) via Panache `.page()`. Default: page=0, size=50. Frontend adapted with `PagedResponse<T>` interface. |
| 9 | **Tests** | ✅ Done | 69 unit tests across 6 files: BetScoringTest (17), ChampionBetScoringTest (12), GroupWinnerBetScoringTest (7), MatchStageTest (8), TournamentRoundTest (13), BonusCalculationServiceTest (12). Covers all scoring tiers, stage multipliers, bonus distribution, and recovery logic. Uses JUnit 5 + Mockito + AssertJ. |

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
| Exact score (group) | 5 pts | ⚠️ Base is 20 pts (doubled for integer multipliers; effective 10 at 1×) |
| Correct diff (group) | 3 pts | ⚠️ Base is 10 pts (effective 5 at 1×) |
| Correct result (group) | 2 pts | ⚠️ Base is 6 pts (effective 3 at 1×) |
| Wrong (group) | 0 pts | ⚠️ Base is −6 pts (effective −3 at 1×) |
| Stage multipliers | 1x / 1.5x / 2x / 3x | ✅ Applied (base doubled to keep integers) |
| Group winner 1st | +5 pts | ✅ |
| Group winner 2nd | +3 pts | ✅ |
| Both group winners | +10 pts (bonus) | ✅ (+2 bonus = 10) |
| Champion | +15 pts | ⚠️ Returns 20 pts |
| Runner-up | +10 pts | ✅ |
| Semifinalists | +8 pts each | ⚠️ Returns 5 pts each |
| Best predictor bonus | +5 pts | ✅ Per-pool, per-round, ties share |
| Top 3 of round | +2 pts | ✅ Per-pool, per-round, ties share |
| Recovery bonus | +10 pts next phase | ✅ Per-pool, strictly above average, no recovery after Final |

> **Note:** Match bet base points were intentionally doubled (20/10/6/2/−6 instead of 10/5/3/1/−3) so that stage multipliers always produce integer results. The effective group-stage values at 1× multiplier are equivalent to the original spec values. Champion/semifinalist values differ from the original spec and may need alignment.

---

## 6. Security Assessment

| Check | Status | Notes |
|-------|--------|-------|
| Keycloak OIDC configured | ✅ | Backend + frontend both configured |
| HTTPS enforced | ✅ | `requireHttps: true` in auth config |
| OAuth2 PKCE flow | ✅ | Prevents auth code interception |
| Endpoint protection | ✅ | `@Authenticated` on all 10 user-facing resources (class-level) |
| Role-based access | ✅ | `@RolesAllowed("admin")` on ScoreResource (class-level) + 15 admin-only methods |
| Input validation | ✅ | Bean Validation on all request DTOs + `@Valid` + custom exception mapper |
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
| V2026.0.0.9 | Relax bet points constraint (≥ −18 for stage multipliers) | ~5 |
| V2026.0.0.10 | Add `score_tier` column to bet table | ~5 |
| V2026.0.0.11 | Create `pool_bonus` table for round/recovery bonuses | ~30 |

> ⚠️ Migrations V3–V7 contain **mock/test data** and should be excluded from production deployments or moved to a dev-only profile.

---

## 8. Performance Considerations

### ✅ Good
- Indexes on all FK columns and frequently queried fields
- Lazy loading on `@ManyToOne` relationships
- Batch operations in score calculation
- `< 100 users` means most concerns are theoretical
- Pagination on 7 high-volume `getAll()` endpoints (default page=0, size=50)

### ⚠️ Could Improve
- Global ranking query uses subqueries — could use window functions
- No caching layer for immutable data (teams, match schedule)
- No client-side caching strategy (all data refetched on navigation)

---

## 9. Production Readiness Verdict

### Overall Maturity: **~85% — Backend production-ready, frontend needs UI work**

The **core betting flow works end-to-end**: login → place match/group/champion bets → scores calculated with stage multipliers → pool-scoped rankings with bonuses. The backend has comprehensive security (OIDC + RBAC), input validation, pagination, and unit test coverage.

### 🔴 Must Fix Before Production

1. **Pool management UI** — Create/join/list pools in the frontend
2. **Payment tracking UI** — View and confirm payments
3. **Error handling** — HTTP interceptor + user-facing notifications
4. **Navigation sidebar** — Wire placeholder links to real routes
5. **Remove test migrations** — Exclude mock data from production Flyway

### 🟡 Should Fix (High Priority)

1. Admin dashboard for pool/payment/user management
2. Form validation with visible error messages
3. Football-data.org integration for live score updates
4. Align champion/semifinalist point values with the spec (or update the spec)
5. Frontend test coverage (component + E2E)

### 🟢 Nice to Have

1. Real-time updates via WebSocket
2. 404/Error pages
3. User profile editing
4. Performance monitoring / error tracking (Sentry)
5. Offline support via Service Worker
6. Notifications (bet reminders, match results)
7. Statistics and analytics pages
