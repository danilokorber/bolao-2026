import { Bet } from './bet.interface';
import { MatchStage } from './match-stage.enum';
import { MatchStatus } from './match-status.enum';
import { Team } from './team.interface';

export interface Match {
  id?: string;
  matchId?: number;
  footballDataMatchId?: number;
  homeTeamId: string;
  awayTeamId: string;
  homeTeam?: Team;
  awayTeam?: Team;
  matchDatetime: string;
  stage: MatchStage;
  homeGoals?: number;
  awayGoals?: number;
  homePenalties?: number;
  awayPenalties?: number;
  homeOdds?: number;
  awayOdds?: number;
  drawOdds?: number;
  wentToExtraTime?: boolean;
  wentToPenalties?: boolean;
  winnerId?: string;
  winner?: Team;
  status: MatchStatus;
  inProgress?: boolean;
  userBet: Bet;
}
