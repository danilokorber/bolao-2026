import { inject, isDevMode } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {
  provideTransloco,
  Translation,
  TranslocoLoader,
  provideTranslocoLoader,
} from '@jsverse/transloco';

export const AVAILABLE_LANGS = ['pt', 'en', 'de'] as const;
export const LANG_LABELS: Record<string, string> = {
  pt: '🇧🇷 Português',
  en: '🇺🇸 English',
  de: '🇩🇪 Deutsch',
};
const FALLBACK_LANG = 'en';
const STORAGE_KEY = 'lang';

function getDefaultLang(): string {
  const stored = typeof localStorage !== 'undefined' ? localStorage.getItem(STORAGE_KEY) : null;
  if (stored && (AVAILABLE_LANGS as readonly string[]).includes(stored)) {
    return stored;
  }
  const browserLang = typeof navigator !== 'undefined' ? navigator.language?.split('-')[0] : null;
  return browserLang && (AVAILABLE_LANGS as readonly string[]).includes(browserLang)
    ? browserLang
    : FALLBACK_LANG;
}

class TranslocoHttpLoader implements TranslocoLoader {
  private http = inject(HttpClient);

  getTranslation(lang: string) {
    return this.http.get<Translation>(`/i18n/${lang}.json`);
  }
}

export const translocoProviders = [
  provideTransloco({
    config: {
      availableLangs: [...AVAILABLE_LANGS],
      defaultLang: getDefaultLang(),
      fallbackLang: FALLBACK_LANG,
      reRenderOnLangChange: true,
      prodMode: !isDevMode(),
    },
  }),
  provideTranslocoLoader(TranslocoHttpLoader),
];
