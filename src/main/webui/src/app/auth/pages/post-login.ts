import { HttpClient } from '@angular/common/http';
import { Component, effect, inject, linkedSignal, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { API } from '@api/api';
import { AuthService } from '@auth/services/auth.service';
import { AppUser } from '@interfaces/app-user.interface';
import { TranslocoPipe } from '@jsverse/transloco';
import { SignalStore } from '../../store/signal-store';

@Component({
  selector: 'post-login',
  imports: [TranslocoPipe],
  template: `
    <img src="logging-in.gif" />
    <div
      class="w-full fixed left-0 bottom-0 pb-4 flex flex-row mx-auto justify-center items-center gap-4"
    >
      <button
        class="px-6 py-3 cursor-pointer text-primary-600 font-bold! rounded transition-colors hover:bg-primary-200"
      >
        {{ 'postLogin.logout' | transloco }}
      </button>
    </div>
  `,
})
export class PostLoginPage {
  private readonly router = inject(Router);
  protected readonly signalStore = inject(SignalStore);

  appUser = this.signalStore.getAppUser();

  redirectToDashboard = effect(() => {
    const user = this.appUser();
    if (user) {
      this.router.navigate(['dashboard']);
    }
  });
}
