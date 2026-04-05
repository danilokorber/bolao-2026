import { Pipe, PipeTransform, inject } from '@angular/core';
import { TeamService } from '@services/team.service';
import { Team } from '@interfaces/team.interface';

@Pipe({ name: 'teamName', standalone: true })
export class TeamNamePipe implements PipeTransform {
  private readonly teamService = inject(TeamService);

  transform(team?: Team): string {
    return team ? this.teamService.localizedName(team) : '';
  }
}
