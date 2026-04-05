import { Component, computed, ElementRef, HostListener, inject, input, output, signal, viewChild } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { FlagFallbackDirective } from '@directives/flag-fallback.directive';
import { Team } from '@interfaces/team.interface';

@Component({
  selector: 'team-select',
  imports: [FlagFallbackDirective],
  template: `
    <div class="relative">
      <!-- Trigger -->
      <button
        type="button"
        class="w-full flex items-center gap-2 px-3 py-2 rounded-lg border text-sm bg-white transition-colors outline-0"
        [class.border-primary-500]="open()"
        [class.ring-1]="open()"
        [class.ring-primary-500]="open()"
        [class.border-gray-300]="!open()"
        (click)="toggle()"
      >
        @if (selectedTeam(); as team) {
          <div class="shrink-0 rounded-full overflow-hidden bg-white h-6 w-6 relative shadow-sm">
            <img
              [imgSrc]="team.flagUrl ?? ''"
              [alt]="team.fifaCode"
              class="absolute inset-0 w-full h-full object-cover"
              style="height: 100%; max-width: none"
              flag-fallback
            />
          </div>
          <span class="flex-1 text-left truncate">{{ localizedName(team) }}</span>
          <span class="text-xs text-gray-400">({{ team.fifaCode }})</span>
        } @else {
          <span class="flex-1 text-left text-gray-400">{{ placeholder() }}</span>
        }
        <svg
          class="shrink-0 w-4 h-4 text-gray-400 transition-transform"
          [class.rotate-180]="open()"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M19 9l-7 7-7-7"
          />
        </svg>
      </button>

      <!-- Dropdown -->
      @if (open()) {
        <div
          class="absolute z-10 mt-1 w-full bg-white border border-gray-200 rounded-lg shadow-lg overflow-hidden"
        >
          <!-- Filter input -->
          <div class="px-2 py-1.5 border-b border-gray-100">
            <input
              #filterInput
              type="text"
              class="w-full px-2 py-1 text-sm border border-gray-200 rounded outline-0 focus:border-primary-400"
              placeholder="🔍"
              [value]="filter()"
              (input)="filter.set(filterInput.value)"
            />
          </div>
          <!-- Scrollable team list -->
          <div class="max-h-[156px] overflow-y-auto">
            @for (team of filteredTeams(); track team.id) {
              <button
                type="button"
                class="w-full flex items-center gap-2 px-3 py-2 text-sm hover:bg-primary-50 transition-colors rounded-none!"
                [class.bg-primary-100]="team.id === value()"
                [class.font-semibold]="team.id === value()"
                (click)="select(team)"
              >
                <div
                  class="shrink-0 rounded-full overflow-hidden bg-white h-6 w-6 relative shadow-sm"
                >
                  <img
                    [imgSrc]="team.flagUrl ?? ''"
                    [alt]="team.fifaCode"
                    class="absolute inset-0 w-full h-full object-cover"
                    style="height: 100%; max-width: none"
                    flag-fallback
                  />
                </div>
                <span class="flex-1 text-left">{{ localizedName(team) }}</span>
                <span class="text-xs text-gray-400">({{ team.fifaCode }})</span>
                @if (team.id === value()) {
                  <span class="text-primary-600">✓</span>
                }
              </button>
            }
          </div>
        </div>
      }
    </div>
  `,
  styles: ``,
})
export class TeamSelect {
  private readonly el = inject(ElementRef);
  private readonly transloco = inject(TranslocoService);
  private readonly filterInput = viewChild<ElementRef>('filterInput');

  teams = input.required<Team[]>();
  value = input<string | null>(null);
  placeholder = input<string>('');

  selected = output<string>();

  open = signal(false);
  filter = signal('');

  sortedTeams = computed(() =>
    [...this.teams()]
      .filter((t) => !!t.flagUrl)
      .sort((a, b) => this.localizedName(a).localeCompare(this.localizedName(b), this.transloco.getActiveLang()))
  );

  filteredTeams = computed(() => {
    const q = this.filter().toLowerCase().trim();
    if (!q) return this.sortedTeams();
    return this.sortedTeams().filter(
      (t) =>
        t.nameEn.toLowerCase().includes(q) ||
        t.nameDe.toLowerCase().includes(q) ||
        t.namePt.toLowerCase().includes(q) ||
        t.fifaCode.toLowerCase().includes(q)
    );
  });

  selectedTeam = () => {
    const id = this.value();
    if (!id) return null;
    return this.teams().find((t) => t.id === id) ?? null;
  };

  localizedName(team: Team): string {
    const lang = this.transloco.getActiveLang();
    switch (lang) {
      case 'de':
        return team.nameDe;
      case 'pt':
        return team.namePt;
      default:
        return team.nameEn;
    }
  }

  toggle() {
    this.open.update((v) => !v);
    if (this.open()) {
      this.filter.set('');
      setTimeout(() => this.filterInput()?.nativeElement.focus());
    }
  }

  select(team: Team) {
    this.selected.emit(team.id!);
    this.open.set(false);
  }

  @HostListener('document:click', ['$event'])
  onClickOutside(event: MouseEvent) {
    if (!this.el.nativeElement.contains(event.target)) {
      this.open.set(false);
    }
  }
}
