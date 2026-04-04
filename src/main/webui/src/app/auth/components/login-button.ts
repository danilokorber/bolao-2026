import { Component, inject, input, linkedSignal } from '@angular/core';
import { TranslocoPipe } from '@jsverse/transloco';
import { AuthProvider } from '@auth/enums/auth-providers';
import { AuthService } from '@auth/services/auth.service';

@Component({
  selector: 'login-button',
  imports: [TranslocoPipe],
  template: `
    <button
      [class]="
        buttonSettings().classes +
        ' flex items-center gap-2'
      "
      [title]="'login.loginWith' | transloco: { provider: providerName() }"
      (click)="click()"
    >
      <i [class]="buttonSettings().icon" style="font-size: 2.5rem"></i>
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
  };

  providerName = linkedSignal(() => {
    const names: { [key in AuthProvider]: string } = {
      [AuthProvider.Google]: 'Google',
      [AuthProvider.Facebook]: 'Facebook',
      [AuthProvider.Twitter]: 'Twitter',
      [AuthProvider.Microsoft]: 'Microsoft',
    };
    return names[this.provider()];
  });

  buttonSettings = linkedSignal(() => this.settings[this.provider()]);

  click() {
    console.log('Logging in with', this.provider());

    this.authService.login(this.provider());
  }
}
