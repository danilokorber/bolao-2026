import { Component, computed, input } from '@angular/core';
import { MatchStatus } from '@interfaces/match-status.enum';
import { MatchV2 } from '@interfaces/match-v2.interface';

@Component({
  selector: 'match-fireworks',
  template: `
    @if (argentinaLost()) {
      <div class="firework absolute -top-20 left-1/4 z-10"></div>
    }
  `,
})
export class MatchFireworks {
  match = input.required<MatchV2>();
  argentinaLost = computed(
    () =>
      this.match().status === MatchStatus.FINISHED &&
      ((this.match().homeTeam?.fifaCode == 'ARG' &&
        (this.match().homeGoals ?? 0) < (this.match().awayGoals ?? 0)) ||
        (this.match().awayTeam?.fifaCode == 'ARG' &&
          (this.match().awayGoals ?? 0) < (this.match().homeGoals ?? 0))),
  );
}
