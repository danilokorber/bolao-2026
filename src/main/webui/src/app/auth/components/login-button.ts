import { Component, inject, input, linkedSignal } from '@angular/core';
import { AuthProvider } from '@auth/enums/auth-providers';
import { AuthService } from '@auth/services/auth.service';

@Component({
  selector: 'login-button',
  imports: [],
  template: `
    <button
      [class]="
        buttonSettings().classes +
        ' px-6 py-3 text-white rounded-lg transition-colors flex items-center gap-2 cursor-pointer'
      "
      [title]="buttonSettings().text"
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

  settings: { [key in AuthProvider]: { text: string; classes: string; icon: string } } = {
    [AuthProvider.Google]: {
      text: 'Entrar com Google',
      classes: 'bg-blue-600 hover:bg-blue-700',
      icon: 'pi pi-google',
    },
    [AuthProvider.Facebook]: {
      text: 'Entrar com Facebook',
      classes: 'bg-blue-800 hover:bg-blue-900',
      icon: 'pi pi-facebook',
    },
    [AuthProvider.Twitter]: {
      text: 'Entrar com Twitter',
      classes: 'bg-gray-700 hover:bg-gray-800',
      icon: 'pi pi-twitter',
    },
    [AuthProvider.Microsoft]: {
      text: 'Entrar com Microsoft',
      classes: 'bg-gray-800 hover:bg-gray-900',
      icon: 'pi pi-microsoft',
    },
  };

  buttonSettings = linkedSignal(() => this.settings[this.provider()]);

  click() {
    console.log('Logging in with', this.provider());

    this.authService.login(this.provider());
  }
}
