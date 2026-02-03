import { UserPoolStatus } from './user-pool-status.enum';
import { AppUser } from './app-user.interface';
import { Pool } from './pool.interface';

export interface UserPool {
  id?: string;
  userId: string;
  poolId: string;
  user?: AppUser;
  pool?: Pool;
  joinedAt?: string;
  status: UserPoolStatus;
}
