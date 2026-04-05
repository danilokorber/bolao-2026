import { httpResource } from '@angular/common/http';
import { Component, computed, effect, inject } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { ChampionBetForm } from '@components/champion-bet-form';
import { ChampionBet, Team } from '@interfaces/index';
import { resourceLoadedOr404, resourceValueOr404 } from '@utils/resource-utils';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'champion-bet',
  imports: [TranslocoPipe, ChampionBetForm],
  templateUrl: './champion-bet.html',
})
export class ChampionBetPage {
  private readonly store = inject(SignalStore);
  private readonly router = inject(Router);

  private userId = computed(() => this.store.appuser()?.id);

  next() {
    this.router.navigate(['/dashboard']);
  }

  teams = httpResource<Team[]>(() => API.TEAMS.GET_ALL());
  deadline = httpResource<{ deadline?: string }>(() => API.CHAMPION_BETS.GET_DEADLINE());

  userBet = httpResource<ChampionBet | null>(() => {
    const id = this.userId();
    return id ? API.CHAMPION_BETS.GET_BY_USER(id) : undefined;
  });

  betValue = computed(() => resourceValueOr404(this.userBet));
  betLoaded = computed(() => resourceLoadedOr404(this.userBet));
  allTeams = computed(() => this.teams.value() ?? []);

  locked = computed(() => {
    const d = this.deadline.value()?.deadline;
    return d ? new Date() >= new Date(d) : false;
  });

  private readonly redirectIfComplete = effect(() => {
    const bet = this.betValue();
    if (!bet) return;
    if (
      bet.championTeamId &&
      bet.runnerUpTeamId &&
      bet.semifinalist1TeamId &&
      bet.semifinalist2TeamId &&
      bet.semifinalist3TeamId &&
      bet.semifinalist4TeamId
    ) {
      this.next();
    }
  });
}
