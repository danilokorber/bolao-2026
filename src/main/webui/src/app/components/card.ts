import { Component } from '@angular/core';

@Component({
  selector: 'card',
  imports: [],
  template: `
    <div class="flex flex-col border border-primary-700 dark:border-primary-200 rounded-t-xl">
      <div class="flex flex-row bg-primary-700 text-white font-bold p-4 text-xl rounded-t-xl">
        <ng-content select="[card-header]"></ng-content>
      </div>
      <div class="flex-1">
        <ng-content></ng-content>
      </div>
    </div>
  `,
  styles: ``,
})
export class Card {}
