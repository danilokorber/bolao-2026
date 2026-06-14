export interface RankingEntry {
  position: number;
  userId: string;
  userName: string;
  isFavorite: boolean;
  countExact: number;
  countDiff: number;
  countWinner: number;
  countInverted: number;
  countWrong: number;
  specialPoints: number;
  totalPoints: number;
}
