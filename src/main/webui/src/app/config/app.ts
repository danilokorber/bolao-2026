import { Component, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { NavigationEnd, Router, RouterOutlet } from '@angular/router';
import { RouteTrackingService } from '@services/route-tracking.service';
import { filter } from 'rxjs';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  template: '<router-outlet></router-outlet>',
  styles: ``,
})
export class App {
  protected readonly title = signal('bolao');

  private readonly router = inject(Router);
  private readonly routeTracking = inject(RouteTrackingService);

  constructor() {
    this.router.events
      .pipe(
        filter((event): event is NavigationEnd => event instanceof NavigationEnd),
        takeUntilDestroyed(),
      )
      .subscribe((event) => this.routeTracking.track(event.urlAfterRedirects));
  }
}
