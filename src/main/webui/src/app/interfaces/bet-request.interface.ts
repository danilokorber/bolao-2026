export interface BetRequest {
  id?: string;
  userId: string;
  matchId: string;
  homeGoalsBet: number;
  awayGoalsBet: number;
  winnerBetId?: string;
}
