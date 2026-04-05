import { Component, input } from '@angular/core';

@Component({
  selector: 'match-in-progress',
  imports: [],
  template: `
    @if (show()) {
      <div class="text-2xl sm:text-4xl text-gray-500 loading-dots">
        <span>.</span><span>.</span><span>.</span><span>.</span><span>.</span>
      </div>
    }
  `,
  styles: `
    .loading-dots span {
      animation: blink 1.4s infinite;
    }

    .loading-dots span:nth-child(2) {
      animation-delay: 0.2s;
    }

    .loading-dots span:nth-child(3) {
      animation-delay: 0.4s;
    }

    .loading-dots span:nth-child(4) {
      animation-delay: 0.6s;
    }

    .loading-dots span:nth-child(5) {
      animation-delay: 0.8s;
    }

    @keyframes blink {
      0%,
      20% {
        opacity: 0.2;
      }
      40% {
        opacity: 1;
      }
      100% {
        opacity: 0.2;
      }
    }
  `,
  host: { class: 'w-full flex justify-center items-center' },
})
export class MatchInProgress {
  show = input<boolean>(false);
}
