import { Injectable } from '@angular/core';

export type ScoreTier = 'EXACT' | 'DIFF' | 'WINNER' | 'INVERTED' | 'WRONG';

@Injectable({ providedIn: 'root' })
export class ScoreService {
  private style: CSSStyleDeclaration | null = null;

  private getStyle(): CSSStyleDeclaration {
    if (!this.style) {
      this.style = getComputedStyle(document.documentElement);
    }
    return this.style;
  }

  private static readonly TIER_CSS_VAR: Record<ScoreTier, string> = {
    EXACT:    '--color-score-10',
    DIFF:     '--color-score-5',
    WINNER:   '--color-score-3',
    INVERTED: '--color-score-1',
    WRONG:    '--color-score-neg',
  };

  color(points: number, tier?: ScoreTier | null): string {
    const s = this.getStyle();

    if (tier) {
      return s.getPropertyValue(ScoreService.TIER_CSS_VAR[tier]).trim();
    }

    // Fallback for non-match bets (group winners, champion) that have no tier
    if (points >= 20) return s.getPropertyValue('--color-score-10').trim();
    if (points >= 10) return s.getPropertyValue('--color-score-5').trim();
    if (points >= 6)  return s.getPropertyValue('--color-score-3').trim();
    if (points >= 1)  return s.getPropertyValue('--color-score-1').trim();
    if (points < 0)   return s.getPropertyValue('--color-score-neg').trim();
    return s.getPropertyValue('--color-score-0').trim();
  }
}
