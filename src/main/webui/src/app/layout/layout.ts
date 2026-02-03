import { isPlatformBrowser } from '@angular/common';
import { Component, effect, inject, PLATFORM_ID, signal } from '@angular/core';
import { Router, RouterModule, NavigationEnd, ActivatedRoute } from '@angular/router';
import { BolaoModule } from '@modules/bolao/bolao.module';
import { filter, map } from 'rxjs/operators';

@Component({
  selector: 'layout',
  imports: [RouterModule, BolaoModule],
  templateUrl: './layout.html',
  styles: ``,
})
export class Layout {
  private platformId = inject(PLATFORM_ID);
  private router = inject(Router);
  private activatedRoute = inject(ActivatedRoute);

  sidebarOpen = signal(false);
  darkMode = signal(false);
  pageTitle = signal<string>('Dashboard');

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
        map((route) => route.snapshot.data['title'] || 'Dashboard')
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
