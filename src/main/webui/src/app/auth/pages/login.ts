import { Component, inject, OnInit } from '@angular/core';
import { LoginButton } from '@auth/components/login-button';
import { TranslocoPipe } from '@jsverse/transloco';
import { AuthService } from '../services/auth.service';
import { AuthProvider } from './../enums/auth-providers';

@Component({
  selector: 'login',
  imports: [LoginButton, TranslocoPipe],
  template: `
    <div class="flex flex-col items-center justify-center h-screen">
      <h1 class="text-4xl font-bold mb-8">{{ 'login.welcome' | transloco }}</h1>
      <div class="w-full max-w-lg flex flex-row space-betweent items-center justify-center gap-4">
        <login-button [provider]="AuthProvider.Google"></login-button>
        <!-- <login-button [provider]="AuthProvider.Facebook"></login-button> -->
        <!-- <login-button [provider]="AuthProvider.Twitter"></login-button> -->
        <login-button [provider]="AuthProvider.Microsoft"></login-button>
        <login-button [provider]="AuthProvider.Linkedin"></login-button>
        <login-button [provider]="AuthProvider.GitHub"></login-button>
      </div>
    </div>
  `,
})
export class LoginPage implements OnInit {
  private readonly authService = inject(AuthService);
  AuthProvider = AuthProvider;

  ngOnInit(): void {
    this.authService.handleCallback();
  }
}
