import { Component, computed, inject, linkedSignal } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { MatchStatus, Team } from '@interfaces/index';
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
  styles: `
    .flag {
      height: 100%;
      max-width: none;
    }
  `,
  host: { class: 'flex flex-col gap-8 w-full mx-auto' },
})
export class MatchDetail {
  private readonly route = inject(ActivatedRoute);
  private readonly transloco = inject(TranslocoService);
  readonly store = inject(SignalStore);
  protected readonly scoreService = inject(ScoreService);
  private readonly stageService = inject(StageService);
  private readonly teamService = inject(TeamService);

  MatchStatus = MatchStatus;

  matchId = this.route.snapshot.paramMap.get('id') ?? '';
  private userId = computed(() => this.store.appuser()?.id);

  match = this.store.match(this.matchId);
  bets = computed(() => this.match()?.bets ?? []);

  isZebra = computed(() => {
    const bets = this.match()!.bets ?? [];
    if (bets.length === 0) return false; // No bets, default to non-zebra

    const betsWrong = bets.filter((bet) => bet.pointsEarned === -6).length;
    return betsWrong / bets.length >= 0.75; // Zebra if 75% or more bets are wrong
  });

  sortedBets = computed(() => {
    const list = this.bets() ?? [];
    return [...list].sort((a, b) => (b.pointsEarned ?? 0) - (a.pointsEarned ?? 0));
  });

  localizedName(team?: Team): string {
    return team ? this.teamService.localizedName(team) : '';
  }

  stageLabel = linkedSignal(() => this.stageService.fullLabel(this.match()?.stage));

  formattedDate = linkedSignal(() => {
    const dt = this.match()?.matchDatetime;
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
