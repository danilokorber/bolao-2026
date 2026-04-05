import { Component, input } from '@angular/core';
import { SaveState } from '@services/bet-save.service';

@Component({
  selector: 'save-indicator',
  template: `
    @if (state().saving) {
      <span class="text-xs opacity-50">…</span>
    } @else if (state().saved) {
      <span class="text-primary-600 text-sm saved-flash">✓</span>
    }
  `,
  host: { class: 'inline-flex items-center' },
})
export class SaveIndicator {
  state = input.required<SaveState>();
}
