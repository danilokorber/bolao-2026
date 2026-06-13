import { Component, computed, inject } from '@angular/core';
import { Router } from '@angular/router';
import { Bet, MatchStatus } from '@interfaces/index';
import { TranslocoPipe } from '@jsverse/transloco';
import { ScoreService } from '@services/score.service';
import { StageService } from '@services/stage.service';
import { utcDate } from '@utils/date-utils';
import { SignalStore } from '../store/signal-store';
import { Card } from './card';
import { RecentResultsCardItem } from './recent-results-card-item';
import { RecentResultsCardItemSkeleton } from './recent-results-card-item-skeleton';

@Component({
  selector: 'recent-results-card',
  imports: [Card, TranslocoPipe, RecentResultsCardItem, RecentResultsCardItemSkeleton],
  template: `
    <card>
      <div card-header>{{ 'dashboard.recentResults.title' | transloco }}</div>
      <div class="p-0">
        <div class="flex flex-col">
          @if (!store.betsInitiallyLoaded()) {
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
            <recent-results-card-item-skeleton></recent-results-card-item-skeleton>
          } @else {
            @for (bet of recentBets(); track bet.id) {
              <recent-results-card-item [bet]="bet"></recent-results-card-item>
            } @empty {
              <p class="text-sm opacity-60 px-3 py-2">
                {{ 'dashboard.recentResults.noData' | transloco }}
              </p>
            }
          }
        </div>
      </div>
    </card>
  `,
  styles: ``,
})
export class RecentResultsCard {
  protected readonly store = inject(SignalStore);
  private readonly router = inject(Router);
  protected readonly scoreService = inject(ScoreService);
  protected readonly stageService = inject(StageService);

  bets = this.store.allBets;

  currentUserId = computed(() => this.store.appuser()?.id);

  recentBets = computed(() => {
    if (!this.bets) {
      return [];
    }

    const userId = this.currentUserId();
    const now = Date.now();

    const finished = this.bets()!.filter(
      (b) =>
        b.match &&
        b.match.status === MatchStatus.FINISHED &&
        utcDate(b.match.matchDatetime).getTime() < now,
    );

    // Group bets by match, prefer current user's bet
    const byMatch = new Map<string, Bet>();
    for (const b of finished) {
      const mid = b.matchId;
      if (!byMatch.has(mid) || b.userId === userId) {
        byMatch.set(mid, b);
      }
    }

    return [...byMatch.values()]
      .sort((a, b) => {
        const distA = Math.abs(utcDate(a.match!.matchDatetime).getTime() - now);
        const distB = Math.abs(utcDate(b.match!.matchDatetime).getTime() - now);
        return distA - distB;
      })
      .slice(0, 5);
  });
}
