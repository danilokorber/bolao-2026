import { signalStore, withFeature, withHooks } from '@ngrx/signals';
// import { withBetsFeature } from './features/bets.feature';
import { MATCHESV2_REFRESH_INTERVAL, withMatchesV2Feature } from './features/matchesV2.feature';
import { RANKING_REFRESH_INTERVAL, withRankingFeature } from './features/ranking.feature';
import { withUserFeature } from './features/user.feature';

export const SignalStore = signalStore(
  { providedIn: 'root' },

  withFeature(withMatchesV2Feature),
  withFeature(withRankingFeature),
  withFeature(withUserFeature),

  withHooks({
    onInit({ loadMatchesV2, loadRanking, loadHistory, loadAppUser }) {
      // Load once on init
      loadMatchesV2();
      loadRanking();
      loadHistory();
      loadAppUser();

      // Load recurrently
      setInterval(() => loadMatchesV2(), MATCHESV2_REFRESH_INTERVAL);
      setInterval(() => loadRanking(), RANKING_REFRESH_INTERVAL);
      setInterval(() => loadHistory(), RANKING_REFRESH_INTERVAL);
    },
  }),
);
