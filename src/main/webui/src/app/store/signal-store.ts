import { signalStore, withFeature, withHooks } from '@ngrx/signals';
import { BETS_REFRESH_INTERVAL, withBetsFeature } from './features/bets.feature';
import { MATCHES_REFRESH_INTERVAL, withMatchesFeature } from './features/matches.feature';
import { withUserFeature } from './features/user.feature';

export const SignalStore = signalStore(
  { providedIn: 'root' },

  withFeature(withMatchesFeature),
  withFeature(withBetsFeature),
  withFeature(withUserFeature),

  withHooks({
    onInit({ loadMatches, loadBets, loadAppUser }) {
      // Load once on init
      loadMatches();
      loadBets();
      loadAppUser();

      // Load recurrently
      setInterval(() => loadMatches(), MATCHES_REFRESH_INTERVAL);
      setInterval(() => loadBets(), BETS_REFRESH_INTERVAL);
    },
  }),
);
