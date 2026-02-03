import { AppUser } from './app-user.interface';
import { Team } from './team.interface';

export interface ChampionBet {
  id?: string;
  userId: string;
  user?: AppUser;
  championTeamId?: string;
  championTeam?: Team;
  runnerUpTeamId?: string;
  runnerUpTeam?: Team;
  semifinalist1TeamId?: string;
  semifinalist1Team?: Team;
  semifinalist2TeamId?: string;
  semifinalist2Team?: Team;
  semifinalist3TeamId?: string;
  semifinalist3Team?: Team;
  semifinalist4TeamId?: string;
  semifinalist4Team?: Team;
  betAt?: string;
  bonusPoints?: number;
  calculatedPoints?: number;
}
