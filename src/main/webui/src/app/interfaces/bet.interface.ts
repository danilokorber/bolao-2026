import { AppUser } from './app-user.interface';
import { Match } from './match.interface';
import { Team } from './team.interface';

export interface Bet {
  id?: string;
  userId: string;
  matchId: string;
  user?: AppUser;
  match?: Match;
  homeGoalsBet: number;
  awayGoalsBet: number;
  winnerBetId?: string;
  winnerBet?: Team;
  pointsEarned?: number;
  calculatedPoints?: number;
  betAt?: string;
}
