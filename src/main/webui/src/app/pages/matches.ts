import { httpResource } from '@angular/common/http';
import { afterRenderEffect, Component } from '@angular/core';
import { API } from '@api/api';
import { MatchCard } from '@components/match-card';
import { Match } from '@interfaces/match.interface';
import { BolaoModule } from '@modules/bolao/bolao.module';

@Component({
  selector: 'matches',
  imports: [BolaoModule, MatchCard],
  templateUrl: './matches.html',
  styles: ``,
})
export class Matches {
  matches = httpResource<Match[]>(() => API.MATCHES.GET_ALL());

  _ = afterRenderEffect(() => {
    if (this.matches.hasValue()) {
      const dateAnchor = new Date().toISOString().split('T')[0];
      const element = document.getElementById(dateAnchor);
      if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    }
  });
}
