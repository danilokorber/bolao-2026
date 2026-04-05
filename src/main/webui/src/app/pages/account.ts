import { Component, inject, signal, viewChild, ElementRef } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe, TranslocoService } from '@jsverse/transloco';
import { AVAILABLE_LANGS, LANG_LABELS } from '../config/transloco.config';

@Component({
  selector: 'account',
  imports: [TranslocoPipe],
  templateUrl: './account.html',
  styles: ``,
})
export class Account {
  private readonly router = inject(Router);
  private readonly transloco = inject(TranslocoService);

  scoringDialog = viewChild<ElementRef<HTMLDialogElement>>('scoringDialog');

  languages = AVAILABLE_LANGS.map((code) => ({ code, label: LANG_LABELS[code] }));
  activeLang = signal(this.transloco.getActiveLang());

  changeLang(lang: string) {
    this.transloco.setActiveLang(lang);
    this.activeLang.set(lang);
    localStorage.setItem('lang', lang);
  }

  openScoringDialog() {
    this.scoringDialog()?.nativeElement.showModal();
  }

  closeScoringDialog() {
    this.scoringDialog()?.nativeElement.close();
  }

  onDialogBackdropClick(event: MouseEvent) {
    const dialog = this.scoringDialog()?.nativeElement;
    if (event.target === dialog) {
      dialog?.close();
    }
  }

  logout() {
    this.router.navigate(['/logout']);
  }
}
