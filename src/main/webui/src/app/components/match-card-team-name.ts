import { Component, inject, input, linkedSignal } from '@angular/core';
import { Team } from '@interfaces/team.interface';
import { TeamService } from '@services/team.service';
import { MatchCardHelper } from './match-card-helper';

@Component({
  selector: 'match-card-team-name',
  imports: [],
  template: `
    <span
      class="hidden sm:block"
      [class.text-right]="homeAway() === 'home'"
      [class.text-left]="homeAway() === 'away'"
    >
      {{ localizedName() }}
    </span>
    <span
      class="block sm:hidden"
      [class.text-right]="homeAway() === 'home'"
      [class.text-left]="homeAway() === 'away'"
    >
      {{ team().fifaCode }}
    </span>
  `,
  styles: ``,
  host: { class: 'flex-1 text-xs sm:text-2xl font-semibold' },
})
export class MatchCardTeamName extends MatchCardHelper {
  private readonly teamService = inject(TeamService);

  homeAway = input.required<'home' | 'away'>();

  localizedName = linkedSignal(() => this.teamService.localizedName(this.team()));
}
