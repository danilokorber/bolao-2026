import { MatchStage } from './match-stage.enum';
import { MatchStatus } from './match-status.enum';
import { Team } from './team.interface';

export interface Match {
  id?: string;
  homeTeamId: string;
  awayTeamId: string;
  homeTeam?: Team;
  awayTeam?: Team;
  matchDatetime: string;
  stage: MatchStage;
  homeGoals?: number;
  awayGoals?: number;
  wentToExtraTime?: boolean;
  wentToPenalties?: boolean;
  winnerId?: string;
  winner?: Team;
  status: MatchStatus;
}
