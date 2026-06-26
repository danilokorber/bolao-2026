import { Component } from '@angular/core';
import packageJson from '@root/package.json';

export const VERSION: string = packageJson.version;

@Component({
  selector: 'version',
  imports: [],
  template: `
    <div class="absolute top-2 right-2">
      <p class="text-sm dark:text-primary-800 text-gray-300">{{ version }}</p>
    </div>
  `,
  styles: ``,
})
export class Version {
  version = VERSION;
}
