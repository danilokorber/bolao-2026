import { Injectable, inject } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';

@Injectable({ providedIn: 'root' })
export class StageService {
  private readonly transloco = inject(TranslocoService);

  /** Short abbreviation for compact displays (e.g. ranking rows) */
  shortLabel(stage?: string): string {
    if (!stage) return '';
    if (stage.startsWith('GROUP_')) return stage.charAt(6);
    switch (stage) {
      case 'ROUND_OF_32':   return 'R32';
      case 'ROUND_OF_16':   return 'R16';
      case 'QUARTER_FINALS': return 'QF';
      case 'SEMI_FINALS':    return 'SF';
      case 'THIRD_PLACE':    return '3rd';
      case 'FINAL':          return 'F';
      default:               return '';
    }
  }

  /** Translated full label for detail views */
  fullLabel(stage?: string): string {
    if (!stage) return '';
    if (stage.startsWith('GROUP_'))
      return this.transloco.translate('matchDetail.group') + ' ' + stage.charAt(6);
    switch (stage) {
      case 'ROUND_OF_32':   return this.transloco.translate('matchDetail.stages.r32');
      case 'ROUND_OF_16':   return this.transloco.translate('matchDetail.stages.r16');
      case 'QUARTER_FINALS': return this.transloco.translate('matchDetail.stages.qf');
      case 'SEMI_FINALS':    return this.transloco.translate('matchDetail.stages.sf');
      case 'FINAL':          return this.transloco.translate('matchDetail.stages.final');
      default:               return '';
    }
  }
}
