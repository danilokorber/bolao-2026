import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class ScoreService {
  private style: CSSStyleDeclaration | null = null;

  private getStyle(): CSSStyleDeclaration {
    if (!this.style) {
      this.style = getComputedStyle(document.documentElement);
    }
    return this.style;
  }

  color(points: number): string {
    const s = this.getStyle();
    if (points >= 20) return s.getPropertyValue('--color-score-10').trim();
    if (points >= 10) return s.getPropertyValue('--color-score-5').trim();
    if (points >= 6)  return s.getPropertyValue('--color-score-3').trim();
    if (points >= 1)  return s.getPropertyValue('--color-score-1').trim();
    if (points < 0)   return s.getPropertyValue('--color-score-neg').trim();
    return s.getPropertyValue('--color-score-0').trim();
  }
}
