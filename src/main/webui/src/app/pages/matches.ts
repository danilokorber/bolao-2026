import { httpResource } from '@angular/common/http';
import { afterRenderEffect, Component } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { MatchCard } from '@components/match-card';
import { Bet } from '@interfaces/index';
import { Match } from '@interfaces/match.interface';
import { BolaoModule } from '@modules/bolao/bolao.module';

@Component({
  selector: 'matches',
  imports: [BolaoModule, MatchCard, TranslocoPipe],
  templateUrl: './matches.html',
  styles: ``,
})
export class Matches {
  matches = httpResource<Match[]>(() => API.MATCHES.GET_ALL());
  bets = httpResource<Bet[]>(() => API.BETS.GET_ALL());

  _ = afterRenderEffect(() => {
    if (this.matches.hasValue()) {
      const dateAnchor = new Date().toISOString().split('T')[0];
      const element = document.getElementById(dateAnchor);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  });

  getBetForMatch(matchId: string | undefined): Bet | undefined {
    if (this.bets.hasValue() && matchId) {
      return this.bets.value().find((bet) => bet.matchId === matchId);
    }
    return undefined;
  }
}
