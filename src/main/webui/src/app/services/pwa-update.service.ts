import { ApplicationRef, inject, Injectable } from '@angular/core';
import { SwUpdate, VersionEvent } from '@angular/service-worker';
import { concat, interval } from 'rxjs';
import { filter, first } from 'rxjs/operators';

/** How often long-lived tabs poll the server for a newly deployed version. */
const UPDATE_CHECK_INTERVAL_MS = 30 * 60 * 1000; // 30 minutes

/**
 * Keeps the PWA up to date with the deployed version.
 *
 * The app is served by `ngsw-worker.js`, which caches the built bundle, so
 * without explicit update handling clients keep running an old cached version
 * until a manual hard refresh. This service detects a newly deployed version
 * and reloads the page so users always run the latest code.
 */
@Injectable({ providedIn: 'root' })
export class PwaUpdateService {
  private readonly swUpdate = inject(SwUpdate);
  private readonly appRef = inject(ApplicationRef);

  init(): void {
    // Disabled in dev mode or when service workers are unsupported.
    if (!this.swUpdate.isEnabled) {
      return;
    }

    this.reloadOnNewVersion();
    this.reloadOnUnrecoverableState();
    this.pollForUpdates();
  }

  private reloadOnNewVersion(): void {
    this.swUpdate.versionUpdates
      .pipe(filter((event: VersionEvent) => event.type === 'VERSION_READY'))
      .subscribe(() => this.activateAndReload());
  }

  private reloadOnUnrecoverableState(): void {
    // The cached app is broken (e.g. resources missing from cache); a reload
    // forces a clean fetch from the server.
    this.swUpdate.unrecoverable.subscribe(() => document.location.reload());
  }

  private pollForUpdates(): void {
    // Wait until the app stabilizes, then check immediately and on an interval.
    const appStable$ = this.appRef.isStable.pipe(first((stable) => stable));
    concat(appStable$, interval(UPDATE_CHECK_INTERVAL_MS)).subscribe(() => {
      this.swUpdate.checkForUpdate().catch(() => {
        // Best-effort: ignore transient network errors while checking.
      });
    });
  }

  private activateAndReload(): void {
    this.swUpdate
      .activateUpdate()
      .then(() => document.location.reload())
      .catch(() => {
        // If activation fails, reload anyway to pick up the new version.
        document.location.reload();
      });
  }
}
