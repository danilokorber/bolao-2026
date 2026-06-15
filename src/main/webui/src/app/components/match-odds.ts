import { CommonModule } from '@angular/common';
import { Component, input } from '@angular/core';
import { MatchV2 } from '@interfaces/index';

@Component({
  selector: 'match-odds',
  imports: [CommonModule],
  template: `
    <div class="flex-1 text-right">{{ match().homeOdds | number: '1.2-2' }}</div>
    <div class="w-20 text-center">{{ match().drawOdds | number: '1.2-2' }}</div>
    <div class="flex-1 text-left">{{ match().awayOdds | number: '1.2-2' }}</div>
  `,
  styles: ``,
  host: { class: 'w-full flex flex-row justify-center items-center text-xs gap-1 md:gap-6' },
})
export class MatchOdds {
  match = input.required<MatchV2>();
}
