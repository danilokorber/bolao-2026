import { httpResource } from '@angular/common/http';
import { Component, computed, inject, linkedSignal } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { API } from '@api/api';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Bet, Match, Team } from '@interfaces/index';
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
  private readonly router = inject(Router);
  private readonly transloco = inject(TranslocoService);
  private readonly store = inject(SignalStore);

  matchId = this.route.snapshot.paramMap.get('id') ?? '';
  private userId = computed(() => this.store.appuser()?.id);

  match = httpResource<Match>(() => API.MATCHES.GET_BY_ID(this.matchId, this.userId()));
  bets = httpResource<Bet[]>(() => API.BETS.GET_BY_MATCH(this.matchId));

  sortedBets = computed(() => {
    const list = this.bets.value() ?? [];
    return [...list].sort((a, b) => (b.pointsEarned ?? 0) - (a.pointsEarned ?? 0));
  });

  localizedName(team?: Team): string {
    if (!team) return '';
    const lang = this.transloco.getActiveLang();
    switch (lang) {
      case 'de':
        return team.nameDe;
      case 'pt':
        return team.namePt;
      default:
        return team.nameEn;
    }
  }

  stageLabel = linkedSignal(() => {
    const stage = this.match.value()?.stage;
    if (!stage) return '';
    if (stage.startsWith('GROUP_'))
      return this.transloco.translate('matchDetail.group') + ' ' + stage.charAt(6);
    switch (stage) {
      case 'ROUND_OF_32':
        return this.transloco.translate('matchDetail.stages.r32');
      case 'ROUND_OF_16':
        return this.transloco.translate('matchDetail.stages.r16');
      case 'QUARTER_FINALS':
        return this.transloco.translate('matchDetail.stages.qf');
      case 'SEMI_FINALS':
        return this.transloco.translate('matchDetail.stages.sf');
      case 'FINAL':
        return this.transloco.translate('matchDetail.stages.final');
      default:
        return '';
    }
  });

  formattedDate = linkedSignal(() => {
    const dt = this.match.value()?.matchDatetime;
    if (!dt) return '';
    const d = new Date(dt);
    return d.toLocaleDateString(this.transloco.getActiveLang(), {
      weekday: 'short',
      day: '2-digit',
      month: 'short',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  });

  scoreColor(points: number): string {
    const style = getComputedStyle(document.documentElement);
    if (points >= 10) return style.getPropertyValue('--color-score-10').trim();
    if (points >= 5) return style.getPropertyValue('--color-score-5').trim();
    if (points >= 3) return style.getPropertyValue('--color-score-3').trim();
    if (points >= 1) return style.getPropertyValue('--color-score-1').trim();
    return style.getPropertyValue('--color-score-0').trim();
  }

  goBack() {
    window.history.back();
  }
}
