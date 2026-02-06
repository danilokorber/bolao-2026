import { Component, inject, input, linkedSignal } from '@angular/core';
import { isActive, IsActiveMatchOptions, Router } from '@angular/router';

export enum ICON {
  HOME = 'home',
  RANKING = 'ranking',
  BALL = 'ball',
  USER = 'user',
}

@Component({
  selector: 'icon',
  standalone: true,
  template: `
    <div class="gif-container cursor-pointer">
      @if (isActive()) {
        <img [src]="activeImage()" class="static" alt="Static frame" />
      } @else {
        <img [src]="inactiveImage()" class="static" alt="Static frame" />
      }
      <img [src]="animatedImage()" class="animated" alt="Animated GIF" (click)="onClick()" />
    </div>
  `,
  host: { class: 'cursor-pointer' },
  styles: [
    `
      .gif-container {
        position: relative;
        display: inline-block;
      }

      .gif-container img {
        display: block;
        width: 100%;
        transition: opacity 0.2s;
        height: 40px;
        width: 40px;
      }

      .gif-container .animated {
        position: absolute;
        top: 0;
        left: 0;
        opacity: 0;
        transition: opacity 0.2s;
        scale: 1.3;
      }

      .gif-container:hover .animated {
        opacity: 1;
      }

      .gif-container:hover .static {
        opacity: 0;
      }
    `,
  ],
})
export class IconComponent {
  private readonly router = inject(Router);

  icon = input.required<ICON>();

  inactiveImage = linkedSignal<string>(() => `icons/${this.icon()}-inactive.png`);
  activeImage = linkedSignal<string>(() => `icons/${this.icon()}-active.png`);
  animatedImage = linkedSignal<string>(() => `icons/${this.icon()}-animated.gif`);

  onClick() {
    switch (this.icon()) {
      case ICON.HOME:
        this.router.navigate(['/']);
        break;
      case ICON.RANKING:
        this.router.navigate(['/ranking']);
        break;
      case ICON.BALL:
        this.router.navigate(['/matches']);
        break;
      case ICON.USER:
        this.router.navigate(['/profile']);
        break;
    }
  }

  isActive = linkedSignal<boolean>(() => {
    const params: IsActiveMatchOptions = {
      paths: 'exact',
      queryParams: 'ignored',
      fragment: 'ignored',
      matrixParams: 'ignored',
    };

    if (isActive('/', this.router, params)() && this.icon() === ICON.HOME) return true;
    if (isActive('/matches', this.router, params)() && this.icon() === ICON.BALL) return true;
    return false;
  });
}
