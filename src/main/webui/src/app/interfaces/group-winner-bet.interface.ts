import { GroupName } from './group-name.enum';
import { AppUser } from './app-user.interface';
import { Team } from './team.interface';

export interface GroupWinnerBet {
  id?: string;
  userId: string;
  user?: AppUser;
  groupName: GroupName;
  firstPlaceTeamId: string;
  firstPlaceTeam?: Team;
  secondPlaceTeamId: string;
  secondPlaceTeam?: Team;
  betAt?: string;
  pointsEarned?: number;
  calculatedPoints?: number;
}
