import { httpResource } from '@angular/common/http';
import { Component } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { MatchCard } from '@components/match-card';
import { Match } from '@interfaces/match.interface';
import { BolaoModule } from '@modules/bolao/bolao.module';

@Component({
  selector: 'dashboard',
  imports: [BolaoModule, MatchCard, TranslocoPipe],
  templateUrl: './dashboard.html',
  styles: ``,
})
export class Dashboard {
  matches = httpResource<Match[]>(() => API.MATCHES.GET_UPCOMING(6));
}
