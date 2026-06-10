import { Component, inject, input, linkedSignal } from '@angular/core';
import { AuthProvider } from '@auth/enums/auth-providers';
import { AuthService } from '@auth/services/auth.service';
import { TranslocoPipe } from '@jsverse/transloco';

@Component({
  selector: 'login-button',
  imports: [TranslocoPipe],
  template: `
    <button
      [class]="buttonSettings().classes + ' flex items-center justify-center gap-2 w-16 h-16'"
      [title]="'login.loginWith' | transloco: { provider: providerName() }"
      (click)="click()"
    >
      <i [class]="buttonSettings().icon" style="font-size: 1.5rem"></i>
    </button>
  `,
  styles: ``,
})
export class LoginButton {
  private readonly authService = inject(AuthService);
  provider = input.required<AuthProvider>();

  settings: { [key in AuthProvider]: { classes: string; icon: string } } = {
    [AuthProvider.Google]: {
      classes: 'bg-blue-600 hover:bg-blue-700! text-white!',
      icon: 'pi pi-google',
    },
    [AuthProvider.Facebook]: {
      classes: 'bg-blue-800 hover:bg-blue-900! text-white!',
      icon: 'pi pi-facebook',
    },
    [AuthProvider.Twitter]: {
      classes: 'bg-gray-700 hover:bg-gray-800! text-white!',
      icon: 'pi pi-twitter',
    },
    [AuthProvider.Microsoft]: {
      classes: 'bg-gray-800 hover:bg-gray-900! text-white!',
      icon: 'pi pi-microsoft',
    },
    [AuthProvider.Linkedin]: {
      classes: 'bg-blue-700 hover:bg-blue-800! text-white!',
      icon: 'pi pi-linkedin',
    },
    [AuthProvider.GitHub]: {
      classes: 'bg-gray-900 hover:bg-gray-950! text-white!',
      icon: 'pi pi-github',
    },
  };

  providerName = linkedSignal(() => {
    const names: { [key in AuthProvider]: string } = {
      [AuthProvider.Google]: 'Google',
      [AuthProvider.Facebook]: 'Facebook',
      [AuthProvider.Twitter]: 'Twitter',
      [AuthProvider.Microsoft]: 'Microsoft',
      [AuthProvider.Linkedin]: 'LinkedIn',
      [AuthProvider.GitHub]: 'GitHub',
    };
    return names[this.provider()];
  });

  buttonSettings = linkedSignal(() => this.settings[this.provider()]);

  click() {
    console.log('Logging in with', this.provider());

    this.authService.login(this.provider());
  }
}
