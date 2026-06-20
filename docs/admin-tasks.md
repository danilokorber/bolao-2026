# Admin Tasks — Bolão da Copa 2026

This document describes the administrative tasks for running the World Cup 2026
betting pool. All admin endpoints require the **`admin`** realm role in Keycloak
(`@RolesAllowed("admin")`), except where explicitly noted.

Base API path: `/v1` (some admin-only endpoints live under `/v1/admin`).

---

## Table of Contents

1. [Scoring overview (automatic vs. manual)](#1-scoring-overview)
2. [Match management](#2-match-management)
3. [Knockout slot resolution](#3-knockout-slot-resolution)
4. [Score calculation & recalculation](#4-score-calculation--recalculation)
5. [Teams](#5-teams)
6. [Pools, payments & users](#6-pools-payments--users)
7. [Deleting bets](#7-deleting-bets)
8. [Notifications](#8-notifications)
9. [Reference: scoring rules](#9-reference-scoring-rules)
10. [Reference: slot codes](#10-reference-slot-codes)

---

## 1. Scoring overview

There are two ways points get awarded:

- **Automatic (scheduler).** `MatchUpdateScheduler` runs on a cron
  (`bolao.schedules.matches.schedule`, default **every minute**). It polls
  football-data.org, updates changed matches, and calls
  `ScoreCalculationService.calculatePointsForMatches(...)` for those matches.
  Controlled by `bolao.schedules.matches.enabled` (default **true**).
- **Manual (admin).** You trigger scoring yourself via the score endpoints
  (section 4), or implicitly when you resolve a group slot (section 3).

> **Group-winner and champion bets are NOT scored by the match scheduler.**
> - Group-winner bets are scored when you **resolve both the winner and
>   runner-up slots** of a group (section 3).
> - Match bets are scored automatically once a match finishes (or manually via
>   section 4).

---

## 2. Match management

`MatchResource` — `/v1/matches`

| Task | Method & path | Notes |
|------|---------------|-------|
| Create a match | `POST /v1/matches` | Body: `MatchDTO`. |
| Update a match | `PUT /v1/matches/id/{id}` | Body: `MatchDTO`. Updates score, status, stage, odds, etc. |
| Resolve a knockout slot | `PATCH /v1/matches/resolve-slot` | See section 3. |
| Delete a match | `DELETE /v1/matches/id/{id}` | |

**Key `MatchDTO` fields when updating a result**

- `homeGoals`, `awayGoals` (Integer)
- `status` (`MatchStatus` enum — e.g. `FINISHED`)
- `wentToExtraTime`, `wentToPenalties` (Boolean)
- `winnerId` (UUID of the winning team)
- `stage` (`MatchStage` enum)
- `matchDatetime`
- odds fields

> `PUT /v1/matches/id/{id}` updates the stored match but does **not** itself run
> scoring. Either let the scheduler pick up the change, or recalculate manually
> (section 4).

---

## 3. Knockout slot resolution

When the group stage ends, each knockout match initially points at **placeholder
teams** (e.g. "Winner Group A"). Instead of editing team rows (which collide on
the unique `fifa_code`), you **resolve a slot**: re-point every match FK from the
placeholder team to the real qualifier.

`PATCH /v1/matches/resolve-slot`

**Request body** (`ResolveSlotRequest`):

```json
{
  "slotCode": "WGA",
  "fifaCode": "MEX"
}
```

- `slotCode` — the placeholder's synthetic FIFA code (e.g. `WGA`, `RGB`, `W73`).
  See section 10.
- `fifaCode` — the real qualifying team's FIFA code (e.g. `MEX`).

**Response:** `{ "updatedMatches": N }`

**What it does**

1. Re-points all `home`, `away`, and `winner` foreign keys on affected matches
   from the placeholder team to the real team.
2. Records the mapping on the placeholder row (`placeholder.resolvedTeam = realTeam`).
3. **If the slot is a group winner/runner-up (`WG*` / `RG*`)**, it triggers
   `scoreGroupWinnerBetsFromResolvedSlots(groupName)`.

**Ordering matters for group scoring**

Group-winner bets for a group are only scored once **both** slots of that group
are resolved:

- `WG{letter}` → the group winner (1st place)
- `RG{letter}` → the group runner-up (2nd place)

Resolving only one of the two is a no-op for scoring; resolve both to award the
points. See section 9 for the point values.

**Example — finishing Group A**

```http
PATCH /v1/matches/resolve-slot   { "slotCode": "WGA", "fifaCode": "MEX" }
PATCH /v1/matches/resolve-slot   { "slotCode": "RGA", "fifaCode": "CAN" }
```

After the second call, all group-A winner bets are scored automatically.

**Other knockout rounds**

Resolve later-round placeholders the same way (winners `W73`–`W104`, losers
`L101`/`L102`, third-place qualifiers `M74`, `M77`, …). These re-point match FKs
but do **not** trigger group scoring (only `WG*`/`RG*` do).

---

## 4. Score calculation & recalculation

`ScoreResource` — `/v1/admin/scores`

| Task | Method & path | Body |
|------|---------------|------|
| Calculate for specific matches | `POST /v1/admin/scores/calculate` | `List<UUID>` of match IDs |
| Recalculate one match | `POST /v1/admin/scores/recalculate/{matchId}` | — |
| Recalculate everything | `POST /v1/admin/scores/recalculate-all` | — |

> ⚠️ **Security note:** `@RolesAllowed("admin")` is currently **commented out**
> on `ScoreResource`, so these endpoints are presently **unguarded**. They are
> intended to be admin-only — re-enable the annotation before going live.

Use these when you change a result manually, fix data, or need to reapply the
scoring rules after a logic change.

---

## 5. Teams

`TeamResource` — `/v1/teams`

| Task | Method & path |
|------|---------------|
| Create a team | `POST /v1/teams` |
| Update a team | `PUT /v1/teams/{id}` |
| Delete a team | `DELETE /v1/teams/{id}` |

> Real teams have a `flagUrl`; placeholder teams (group winners, knockout slots)
> have `flagUrl: null` and are filtered out of bet UIs. Do **not** rename a
> placeholder to a real team to "resolve" it — use slot resolution (section 3),
> which avoids the `team_fifa_code_key` unique-constraint collision.

---

## 6. Pools, payments & users

| Resource | Task | Method & path |
|----------|------|---------------|
| Pools (`PoolResource`) | Create | `POST /v1/pools` |
| | Update | `PUT /v1/pools/{id}` |
| | Delete | `DELETE /v1/pools/{id}` |
| Payments (`PaymentResource`) | Update | `PUT /v1/payments/{id}` |
| | Delete | `DELETE /v1/payments/{id}` |
| User-Pools (`UserPoolResource`) | Update | `PUT /v1/user-pools/{id}` |
| | Delete | `DELETE /v1/user-pools/{id}` |
| App Users (`AppUserResource`) | Delete | `DELETE /v1/app-users/{id}` |

---

## 7. Deleting bets

Deleting any user's bet is admin-only:

| Resource | Method & path |
|----------|---------------|
| Match bets (`BetResource`) | `DELETE /v1/bets/{id}` |
| Group-winner bets (`GroupWinnerBetResource`) | `DELETE /v1/group-winner-bets/{id}` |
| Champion bets (`ChampionBetResource`) | `DELETE /v1/champion-bets/{id}` |

---

## 8. Notifications

`AdminNotificationResource` — `/v1/admin/notifications` (entire class is admin)

| Task | Method & path |
|------|---------------|
| Notification stats | `GET /v1/admin/notifications/stats` |

Notification dispatch from the scheduler is gated by
`bolao.notifications.enabled` and `bolao.notifications.event.enabled`.

---

## 9. Reference: scoring rules

**Match bets**

- 10 — exact score
- 5 — correct goal difference
- 3 — correct winner / draw
- 1 — inverted score

**Group-winner bets** (per group, matched by team `id`)

- 5 — correct 1st place
- 3 — correct 2nd place
- +2 — bonus when **both** 1st and 2nd are correct (max 10 per group)

**Champion bets**

- 20 — champion
- 10 — runner-up
- 5 — each correct semifinalist

---

## 10. Reference: slot codes

Placeholder teams use synthetic `fifa_code` values as slot codes:

| Slot family | Codes | Meaning |
|-------------|-------|---------|
| Group winners | `WGA`–`WGL` | 1st place of each group A–L |
| Group runners-up | `RGA`–`RGL` | 2nd place of each group A–L |
| Third-place qualifiers | `M74`, `M77`, `M79`, `M80`, `M81`, `M82`, `M85`, `M87` | Best third-placed teams feeding specific R32 matches |
| Knockout winners | `W73`–`W104` | Winner of match N |
| Knockout losers | `L101`, `L102` | Loser of match N (e.g. third-place playoff) |

Group scoring is triggered only by the `WG*` / `RG*` families. The group letter
is taken from the 3rd character (`slotCode.substring(2)`) and mapped to
`GROUP_<letter>`.

---

## Appendix: running scoring manually (Java 21)

The backend requires **Java 21**. If your local Maven defaults to 17:

```bash
export JAVA_HOME=$(/usr/libexec/java_home -v 21)
./mvnw quarkus:dev
```
