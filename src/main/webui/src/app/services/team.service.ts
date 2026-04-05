import { Injectable, inject } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { Team } from '@interfaces/team.interface';

@Injectable({ providedIn: 'root' })
export class TeamService {
  private readonly transloco = inject(TranslocoService);

  localizedName(team: Team): string {
    switch (this.transloco.getActiveLang()) {
      case 'de': return team.nameDe;
      case 'pt': return team.namePt;
      default:   return team.nameEn;
    }
  }

  sortByName(teams: Team[]): Team[] {
    const lang = this.transloco.getActiveLang();
    return [...teams].sort((a, b) =>
      this.localizedName(a).localeCompare(this.localizedName(b), lang)
    );
  }
}
