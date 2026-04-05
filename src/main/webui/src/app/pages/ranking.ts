import { httpResource } from '@angular/common/http';
import { Component, computed, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { ScoreService } from '@services/score.service';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'ranking-page',
  imports: [TranslocoPipe, RouterLink],
  templateUrl: './ranking.html',
})
export class RankingPage {
  private readonly store = inject(SignalStore);
  readonly scoreService = inject(ScoreService);

  ranking = httpResource<RankingEntry[]>(() => API.RANKING.GET_ALL());
  currentUserId = computed(() => this.store.appuser()?.id);
}
