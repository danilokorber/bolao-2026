import { isPlatformBrowser } from '@angular/common';
import { Component, effect, inject, PLATFORM_ID, signal } from '@angular/core';
import { ActivatedRoute, NavigationEnd, Router, RouterModule } from '@angular/router';
import { ICON, IconComponent } from '@components/icon';
import { BolaoModule } from '@modules/bolao/bolao.module';
import { filter, map } from 'rxjs/operators';

@Component({
  selector: 'navigation-layout',
  imports: [RouterModule, BolaoModule, IconComponent],
  template: `
    <!-- Main container: full screen height -->
    <div
      class="h-dvh w-dvw pb-24 lg:pb-8 flex flex-col items-center gap-4 overflow-y-auto p-4 bg-linear-to-br from-primary-50 via-success-50 to-secondary-50 dark:bg-linear-to-br dark:from-primary-950 dark:via-success-950 dark:to-secondary-950"
    >
      <aside>
        <icon [icon]="ICON.HOME"></icon>
        <icon [icon]="ICON.BALL"></icon>
        <icon [icon]="ICON.RANKING"></icon>
        <icon [icon]="ICON.USER"></icon>
      </aside>

      <div
        id="content"
        class="flex flex-col w-4xl max-w-full bg-white dark:bg-primary-900 border border-gray-300 rounded-t-3xl p-8"
      >
        <router-outlet></router-outlet>
      </div>
    </div>
  `,
  styles: ``,
})
export class NavigationLayout {
  private readonly platformId = inject(PLATFORM_ID);
  private readonly router = inject(Router);
  private readonly activatedRoute = inject(ActivatedRoute);

  sidebarOpen = signal(false);
  darkMode = signal(false);
  pageTitle = signal<string>('Dashboard');
  ICON = ICON;

  constructor() {
    // Initialize theme from localStorage or system preference
    if (isPlatformBrowser(this.platformId)) {
      const savedTheme = localStorage.getItem('theme');
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      const isDark = savedTheme === 'dark' || (!savedTheme && prefersDark);
      this.darkMode.set(isDark);
      this.applyTheme(isDark);

      // Initialize sidebar state based on screen size
      this.updateSidebarForScreenSize();

      // Listen for window resize events
      window.addEventListener('resize', () => this.updateSidebarForScreenSize());
    }

    // Listen for route changes to update page title
    this.router.events
      .pipe(
        filter((event) => event instanceof NavigationEnd),
        map(() => {
          let route = this.activatedRoute;
          while (route.firstChild) {
            route = route.firstChild;
          }
          return route;
        }),
        map((route) => route.snapshot.data['title'] || 'Dashboard'),
      )
      .subscribe((title: string) => {
        this.pageTitle.set(title);
      });

    // Apply theme whenever it changes
    effect(() => {
      if (isPlatformBrowser(this.platformId)) {
        this.applyTheme(this.darkMode());
      }
    });
  }

  toggleSidebar() {
    this.sidebarOpen.update((value) => !value);
  }

  toggleDarkMode() {
    this.darkMode.update((value) => !value);
    if (isPlatformBrowser(this.platformId)) {
      localStorage.setItem('theme', this.darkMode() ? 'dark' : 'light');
    }
  }

  private updateSidebarForScreenSize() {
    const isDesktop = window.innerWidth >= 1024; // lg breakpoint
    this.sidebarOpen.set(isDesktop);
  }

  private applyTheme(isDark: boolean) {
    if (isDark) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }
}
