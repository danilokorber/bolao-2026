import { Component, inject, input, linkedSignal } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { Team } from '@interfaces/team.interface';
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
  private readonly transloco = inject(TranslocoService);

  homeAway = input.required<'home' | 'away'>();

  localizedName = linkedSignal(() => {
    const lang = this.transloco.getActiveLang();
    const team = this.team();
    switch (lang) {
      case 'de':
        return team.nameDe;
      case 'pt':
        return team.namePt;
      default:
        return team.nameEn;
    }
  });
}
