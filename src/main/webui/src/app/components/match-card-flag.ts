import { Component, input } from '@angular/core';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Team } from '@interfaces/team.interface';
import { MatchCardHelper } from './match-card-helper';

@Component({
  selector: 'match-card-flag',
  imports: [FlagFallbackDirective],
  template: `
    <img
      [imgSrc]="team().flagUrl ?? ''"
      [alt]="team().fifaCode"
      class="object-cover rounded-full shadow-2xl bg-white"
      style="height: 6rem; width: 6rem;"
      flag-fallback
    />
  `,
  styles: ``,
})
export class MatchCardFlag extends MatchCardHelper {}
