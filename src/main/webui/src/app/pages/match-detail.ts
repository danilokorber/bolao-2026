import { httpResource } from '@angular/common/http';
import { Component, computed, inject, linkedSignal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { API } from '@api/api';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, Match, Team } from '@interfaces/index';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { ScoreService } from '@services/score.service';
import { StageService } from '@services/stage.service';
import { TeamService } from '@services/team.service';
import { utcDate } from '@utils/date-utils';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'match-detail',
  imports: [TranslocoPipe, FlagFallbackDirective],
  templateUrl: './match-detail.html',
  styles: ``,
  host: { class: 'flex flex-col gap-8 w-full mx-auto' },
})
export class MatchDetail {
  private readonly route = inject(ActivatedRoute);
  private readonly transloco = inject(TranslocoService);
  private readonly store = inject(SignalStore);
  protected readonly scoreService = inject(ScoreService);
  private readonly stageService = inject(StageService);
  private readonly teamService = inject(TeamService);

  matchId = this.route.snapshot.paramMap.get('id') ?? '';
  private userId = computed(() => this.store.appuser()?.id);

  match = httpResource<Match>(() => API.MATCHES.GET_BY_ID(this.matchId, this.userId()));
  bets = httpResource<Bet[]>(() => API.BETS.GET_BY_MATCH(this.matchId));

  constructor() {
    setInterval(() => {
      this.match.reload();
      this.bets.reload();
    }, 60 * 1000); // Refresh match data every minute
  }

  sortedBets = computed(() => {
    const list = this.bets.value() ?? [];
    return [...list].sort((a, b) => (b.pointsEarned ?? 0) - (a.pointsEarned ?? 0));
  });

  localizedName(team?: Team): string {
    return team ? this.teamService.localizedName(team) : '';
  }

  stageLabel = linkedSignal(() => this.stageService.fullLabel(this.match.value()?.stage));

  formattedDate = linkedSignal(() => {
    const dt = this.match.value()?.matchDatetime;
    if (!dt) return '';
    const d = utcDate(dt);
    return d.toLocaleDateString(this.transloco.getActiveLang(), {
      weekday: 'short',
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  });

  goBack() {
    window.history.back();
  }
}
