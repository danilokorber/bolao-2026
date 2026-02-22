import { Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'full-page-layout',
  imports: [RouterModule],
  template: `
    <div
      class="h-dvh w-dvw flex flex-col justify-center align-middle items-center gap-4 overflow-y-auto p-4 bg-linear-to-br from-primary-50 via-success-50 to-secondary-50 dark:bg-linear-to-br dark:from-primary-950 dark:via-success-950 dark:to-secondary-950"
    >
      <router-outlet></router-outlet>
    </div>
  `,
  styles: ``,
})
export class FullPageLayout {}
