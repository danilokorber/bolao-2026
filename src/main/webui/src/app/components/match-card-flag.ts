import { Component, input } from '@angular/core';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Team } from '@interfaces/team.interface';
import { MatchCardHelper } from './match-card-helper';

@Component({
  selector: 'match-card-flag',
  imports: [FlagFallbackDirective],
  template: `
    <div class="shrink-0 rounded-full overflow-hidden shadow-2xl bg-white h-16 w-16 sm:h-24 sm:w-24 relative">
      <img
        [imgSrc]="team().flagUrl ?? ''"
        [alt]="team().fifaCode"
        class="absolute inset-0 w-full h-full object-cover"
        style="height: 100%; max-width: none;"
        flag-fallback
      />
    </div>
  `,
  styles: ``,
})
export class MatchCardFlag extends MatchCardHelper {}
