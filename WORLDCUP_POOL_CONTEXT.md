# World Cup 2026 Betting Pool - Project Context

## Project Overview
Building a betting pool system for the 2026 FIFA World Cup using Quarkus (backend) and Angular (frontend).

**Developer Profile:** Senior Developer in Quarkus and Angular

**Expected Users:** Less than 100 users

**Languages:**
- Technical implementation: English (code, database, API)
- Frontend UI: PT-BR, EN, DE (multilingual)

## Business Rules

### Betting System
- **Single Bet per User**: Users make ONE bet per match, shared across ALL pools they participate in
- **Multiple Pools**: Users can join multiple betting pools, same bets count in all pools
- **Independent Rankings**: Each pool has its own ranking based on active participants

### Scoring Rules

#### Group Stage Matches
- Exact score: 5 points
- Correct result + goal difference: 3 points
- Correct result only: 2 points
- Wrong: 0 points

#### Knockout Stage Matches
- Exact score (regular time): 8 points
- Correct result + goal difference: 5 points
- Correct qualifier only: 3 points
- Wrong: 0 points
- **Important**: If match goes to extra time/penalties, only regular time score counts for points

#### Stage Multipliers
- Group Stage: 1x
- Round of 32: 1x
- Round of 16: 1.5x
- Quarter Finals: 2x
- Semi Finals + Final: 3x

#### Special Bets (Made before Round of 16)
- **Group Winners**: Predict 1st and 2nd place of each group (12 groups)
  - 1st place correct: +5 points
  - 2nd place correct: +3 points
  - Both correct: +10 points (bonus)
  
- **Tournament Winners**: Predict before Round of 16 starts
  - Champion correct: +15 points
  - Runner-up correct: +10 points
  - Each semifinalist correct: +8 points

#### Round Bonuses
- Best predictor of the round: +5 points
- Top 3 of the round: +2 points

#### Recovery Bonus
- Users scoring above pool average in a phase: +10 bonus points for next phase

### Pool Management
- **Pool Creation**: Admin creates pools with custom entry fees
- **Invite System**: Each pool has unique invite code
- **Payment Control**: Manual payment confirmation by admin
- **User Status**:
  - PENDING: Joined but payment not confirmed
  - ACTIVE: Can make bets and appears in ranking
  - REMOVED: Kicked out of pool

## Technology Stack

### Backend
- **Framework**: Quarkus
- **Database**: PostgreSQL
- **Authentication**: Keycloak (SSO)
- **Migration**: Flyway

### Frontend
- **Framework**: Angular
- **Languages**: PT-BR, EN, DE (i18n)

## Database Schema

### Core Entities

**app_user**
- id (PK)
- keycloak_id (UK) - UUID from Keycloak
- name
- email (UK)
- created_at
- active

**team**
- id (PK)
- name
- fifa_code (UK) - 3-letter code
- flag_url
- group_name - GROUP_A to GROUP_L

**match**
- id (PK)
- home_team_id (FK → team)
- away_team_id (FK → team)
- match_datetime
- stage - Enum: GROUP_A...GROUP_L, ROUND_OF_32, ROUND_OF_16, QUARTER_FINALS, SEMI_FINALS, FINAL
- home_goals
- away_goals
- went_to_extra_time
- went_to_penalties
- winner_id (FK → team)
- status - Enum: SCHEDULED, LIVE, FINISHED, CANCELLED

**pool**
- id (PK)
- name
- description
- entry_fee (decimal)
- currency - Enum: EUR, USD, BRL
- created_at
- is_active
- invite_code (UK) - Unique code for invites

**user_pool** (Many-to-Many)
- id (PK)
- user_id (FK → app_user)
- pool_id (FK → pool)
- joined_at
- status - Enum: PENDING, ACTIVE, REMOVED

**payment**
- id (PK)
- user_id (FK → app_user)
- pool_id (FK → pool)
- amount (decimal)
- currency
- payment_method - Enum: PIX, CREDIT_CARD, BANK_TRANSFER, CASH, OTHER
- status - Enum: PENDING, PAID, CONFIRMED, REJECTED, REFUNDED
- transaction_id
- paid_at
- confirmed_at

**bet** (One bet per user per match - NO pool_id)
- id (PK)
- user_id (FK → app_user)
- match_id (FK → match)
- home_goals_bet
- away_goals_bet
- winner_bet_id (FK → team) - For knockout matches
- points_earned
- bet_at
- **UK**: (user_id, match_id)

**champion_bet** (One per user - NO pool_id)
- id (PK)
- user_id (FK → app_user) (UK)
- champion_team_id (FK → team)
- runner_up_team_id (FK → team)
- semifinalist1_team_id (FK → team)
- semifinalist2_team_id (FK → team)
- semifinalist3_team_id (FK → team)
- semifinalist4_team_id (FK → team)
- bet_at
- bonus_points

**group_winner_bet** (12 per user, one per group - NO pool_id)
- id (PK)
- user_id (FK → app_user)
- group_name - GROUP_A to GROUP_L
- first_place_team_id (FK → team)
- second_place_team_id (FK → team)
- bet_at
- points_earned
- **UK**: (user_id, group_name)

### Important Constraints
- User can only bet once per match
- User can only have one champion bet
- User can only have one group winner bet per group
- Group winner bets must have different teams for 1st and 2nd place

## Ranking Calculation

Rankings are calculated **per pool** using this logic:

```sql
SELECT 
    u.id,
    u.name,
    COALESCE(SUM(b.points_earned), 0) + 
    COALESCE(SUM(gwb.points_earned), 0) + 
    COALESCE(cb.bonus_points, 0) as total_points
FROM app_user u
JOIN user_pool up ON up.user_id = u.id
LEFT JOIN bet b ON b.user_id = u.id
LEFT JOIN group_winner_bet gwb ON gwb.user_id = u.id
LEFT JOIN champion_bet cb ON cb.user_id = u.id
WHERE up.pool_id = :poolId 
  AND up.status = 'ACTIVE'
GROUP BY u.id, u.name
ORDER BY total_points DESC
```

**Key Points:**
- Same bets are used across all pools
- Only ACTIVE users appear in pool rankings
- Rankings are calculated on-demand (no cache table needed for <100 users)

## Key Features to Implement

### Phase 1 - Core System
1. User authentication via Keycloak
2. Pool creation and invite system
3. Payment tracking (manual confirmation)
4. Match data management
5. Betting interface (match bets, group winners, champion)
6. Points calculation engine
7. Pool rankings

### Phase 2 - Enhancements
1. Real-time updates during matches
2. Notifications (bet reminders, match results)
3. Statistics and analytics
4. Mobile responsive design
5. Multi-language support (PT-BR, EN, DE)

### Phase 3 - Advanced
1. Admin dashboard
2. Payment integration (optional)
3. Social features (comments, chat)
4. Historical data analysis

## Migration Strategy

### Initial Setup
1. Flyway migration V1__initial_schema.sql (already created)
2. Seed data for 48 teams
3. Seed data for 104 matches (World Cup 2026 schedule)

## Next Steps
1. Create JPA entities
2. Create Quarkus REST endpoints
3. Create Angular services and components
4. Implement Keycloak integration
5. Build scoring calculation service

## Notes
- Database table name is `app_user` (not `user` - reserved keyword)
- No admin role in database - controlled via Keycloak
- Bets are locked once match starts (check match_datetime)
- Champion bets locked once Round of 16 starts
- Group winner bets locked when group stage starts

## FIFA 2026 Format
- **48 teams** divided into 12 groups (A-L) with 4 teams each
- **Group stage**: Top 2 from each group + 8 best 3rd place teams advance
- **Knockout**: Round of 32 → Round of 16 → Quarter Finals → Semi Finals → Final
- **Total matches**: 104
