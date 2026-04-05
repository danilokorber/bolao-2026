import { httpResource } from '@angular/common/http';
import { afterRenderEffect, Component, computed, inject } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { MatchCard } from '@components/match-card';
import { Bet } from '@interfaces/index';
import { Match } from '@interfaces/match.interface';
import { BolaoModule } from '@modules/bolao/bolao.module';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'matches',
  imports: [BolaoModule, MatchCard, TranslocoPipe],
  templateUrl: './matches.html',
  styles: ``,
})
export class Matches {
  private readonly store = inject(SignalStore);
  private userId = computed(() => this.store.appuser()?.id);

  matches = httpResource<Match[]>(() => API.MATCHES.GET_ALL(this.userId()));
  bets = httpResource<Bet[]>(() => API.BETS.GET_ALL());

  _ = afterRenderEffect(() => {
    if (this.matches.hasValue() && this.bets.hasValue()) {
      const dateAnchor = new Date().toISOString().split('T')[0];
      const element = document.getElementById(dateAnchor);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  });

  getBetForMatch(match: Match): Bet | undefined {
    return match.userBet?.id ? match.userBet : undefined;
  }
}
