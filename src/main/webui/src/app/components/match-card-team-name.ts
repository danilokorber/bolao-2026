import { Component, input } from '@angular/core';
import { MatchCardHelper } from './match-card-helper';

@Component({
  selector: 'match-card-team-name',
  imports: [],
  template: `
    <span
      class="hidden md:block"
      [class.text-right]="homeAway() === 'home'"
      [class.text-left]="homeAway() === 'away'"
    >
      {{ team().nameEn }}
    </span>
    <span
      class="block md:hidden"
      [class.text-right]="homeAway() === 'home'"
      [class.text-left]="homeAway() === 'away'"
    >
      {{ team().fifaCode }}
    </span>
  `,
  styles: ``,
  host: { class: 'flex-1 text-2xl font-semibold' },
})
export class MatchCardTeamName extends MatchCardHelper {
  homeAway = input.required<'home' | 'away'>();
}
