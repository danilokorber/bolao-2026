import { Component, input } from '@angular/core';
import { Team } from '@interfaces/team.interface';

@Component({
  selector: 'match-card-helper',
  imports: [],
  template: ``,
  styles: ``,
})
export class MatchCardHelper {
  team = input.required<Team>();
}
