import { Component, inject } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../store/signal-store';
import { Card } from './card';
import { MatchCard } from './match-card';

@Component({
  selector: 'live-matches-card',
  imports: [Card, TranslocoPipe, MatchCard],
  template: `
    @if (liveMatches().length > 0) {
      <card>
        <div card-header>
          {{ 'dashboard.liveMatches.title' | transloco }}
        </div>
        <div class="p-4 pt-6 flex flex-col gap-6 sm:gap-8">
          @for (match of liveMatches(); track match.id) {
            <match-card [match]="match"></match-card>
          } @empty {
            <p class="text-sm opacity-60">{{ 'dashboard.liveMatches.noData' | transloco }}</p>
          }
        </div>
      </card>
    }
  `,
  styles: ``,
})
export class LiveMatchesCard {
  private readonly store = inject(SignalStore);
  liveMatches = this.store.liveMatchesV2;
}
