# Bolão da Copa 2026 — Copilot Instructions

## Project Overview

FIFA World Cup 2026 betting pool ("Bolão") application.  
- **Backend:** Quarkus 3 / Java 21, Hibernate Panache, PostgreSQL  
- **Frontend:** Angular 21 (standalone, zoneless, signal-based), Tailwind CSS v4  
- **i18n:** Transloco with 3 languages — Portuguese (pt), English (en), German (de)  
- **Auth:** Keycloak via OAuth2 implicit flow  
- **Expected users:** < 100  

## Architecture

### Backend (`src/main/java/io/easyware/bolao/`)
- **entities/** — JPA entities with Panache  
- **repositories/** — `PanacheRepositoryBase<Entity, UUID>` per entity  
- **services/** — Business logic layer (`@ApplicationScoped`, `@Transactional`)  
- **resources/** — JAX-RS REST endpoints (`@Path("/v1/...")`)  
- **dto/** — Data Transfer Objects for API payloads  
- **mappers/** — MapStruct mappers (entity ↔ DTO)  

### Frontend (`src/main/webui/src/app/`)

```
api/           → API endpoint URL constants
auth/          → OAuth service, guards, login/logout pages
components/    → Reusable UI components (match-card, team-select, etc.)
config/        → App bootstrap, root component, Transloco config
directives/    → Flag image fallback directive
interfaces/    → TypeScript interfaces and enums
layout/        → Page layouts (navigation, clean, full-page)
modules/       → Legacy Angular module (BolaoModule)
pages/         → Route-level page components
pipes/         → Reusable pipes (TeamNamePipe)
routes/        → Route definitions
services/      → Shared injectable services
store/         → Global signal-based state (SignalStore)
utils/         → Pure utility functions and constants
```

## Key Patterns & Conventions

### Angular Patterns
- **Standalone components** — no NgModules, all components use `imports: [...]`
- **Signals everywhere** — `input()`, `output()`, `model()`, `computed()`, `linkedSignal()`, `signal()`, `effect()`
- **httpResource** — declarative data fetching tied to signal dependencies
- **New control flow** — `@if`, `@else`, `@for`, `@switch` (not `*ngIf`/`*ngFor`)
- **Zoneless** — no Zone.js, fully signal-driven change detection

### Services (Single Responsibility)

| Service | Purpose |
|---------|---------|
| `TeamService` | Localized team name lookup and sorting |
| `ScoreService` | Score-to-color mapping from CSS variables |
| `StageService` | Match stage label formatting (short/full) |
| `BetSaveService` | Generic HTTP POST with saving/saved feedback state |
| `SignalStore` | Global state: current user |

### Utilities

| Utility | Purpose |
|---------|---------|
| `resourceValueOr404()` | Extracts httpResource value, treating 404 as `null` |
| `resourceLoadedOr404()` | Returns true when httpResource loaded or got 404 |
| `SAVE_FEEDBACK_DURATION_MS` | Consistent save confirmation timeout (2500ms) |

### Pipes

| Pipe | Purpose |
|------|---------|
| `TeamNamePipe` | Template pipe for `{{ team \| teamName }}` |

### Child Components (Single Responsibility)

| Component | Purpose |
|-----------|---------|
| `SaveIndicator` | Tiny inline component showing saving/saved feedback from a `SaveState` object |
| `ScoringDialog` | Self-contained `<dialog>` with scoring rules; exposes `open()`/`close()` methods |
| `ChampionBetForm` | Shared champion + semifinalist bet form; accepts `mode: 'card' \| 'compact'` and `teams`/`bet` inputs; owns save logic |
| `GroupBetCard` | Single group winner bet card (header + two team-selects + save indicator); used in group-winner-bets grid |
| `GroupBetRow` | Compact group winner bet row (badge + two team-selects + save indicator); used in account page |

### API Pattern
All bet endpoints use **upsert via single POST** (no separate PUT):
- `POST /api/v1/bets` — upsert by userId + matchId
- `POST /api/v1/group-winner-bets` — upsert by userId + groupName
- `POST /api/v1/champion-bets` — upsert by userId

### BetSaveService Pattern
Components implement the `SaveState` interface (`{ saving, saved }`) and pass themselves (or a state object) to `BetSaveService.save()`, which manages the saving/saved lifecycle automatically.

### httpResource 404 Handling
Some endpoints return 404 when no entity exists yet (e.g., champion bet for new user). Use `resourceValueOr404()` and `resourceLoadedOr404()` from `@utils/resource-utils` to treat 404 as "loaded but empty" instead of error.

### Team Filtering
- **Real teams** have a `flagUrl`; placeholder teams (e.g., "Winner Group A") have `flagUrl: null`
- `TeamSelect` component filters out placeholders automatically via `!!t.flagUrl`
- Teams are always sorted alphabetically by localized name via `TeamService.sortByName()`

### Localization
- JSON files at `public/i18n/{en,pt,de}.json`
- Use `TranslocoPipe` in templates: `{{ 'key' | transloco }}`
- Use `TranslocoService` in TypeScript for programmatic access
- Team names are stored in 3 columns: `nameEn`, `namePt`, `nameDe`

### Path Aliases (tsconfig.json)
```
@api/*         → src/app/api/*
@auth/*        → src/app/auth/*
@components/*  → src/app/components/*
@directives/*  → src/app/directives/*
@interfaces/*  → src/app/interfaces/*
@layout/*      → src/app/layout/*
@pipes/*       → src/app/pipes/*
@services/*    → src/app/services/*
@store/*       → src/app/store/*
@utils/*       → src/app/utils/*
```

### CSS/Styling
- Tailwind CSS v4 with custom color tokens (`primary-*`, `secondary-*`, `score-*`)
- Score colors via CSS custom properties: `--color-score-0` through `--color-score-10`
- `saved-flash` animation defined globally in `styles.css` (do not duplicate in component styles)
- Flag images require `style="height: 100%; max-width: none;"` inline due to global CSS reset
- `FlagFallbackDirective` provides fallback for broken flag image URLs

### Scoring System
- **Match bets:** 10 (exact), 5 (goal diff), 3 (winner), 1 (inverted)
- **Group winners:** 5 (1st place), 3 (2nd place), +2 (both correct)
- **Champion bets:** 20 (champion), 10 (runner-up), 5 (each semifinalist)

## Development Commands
```bash
# Frontend
cd src/main/webui
npx ng build          # Build
npx ng serve          # Dev server

# Backend (requires Java 21)
./mvnw quarkus:dev    # Dev mode with hot reload
```

## Important Notes
- Backend requires Java 21; local env may have Java 17
- The `match-card-bet-form.ts` uses Angular experimental signal forms (`@angular/forms/signals`)
- `BolaoModule` in `modules/` is a legacy wrapper — new code should use standalone components
- The `MatchCardHelper` base class provides a shared `team` input for match card sub-components
