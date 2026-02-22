import { Component, inject, OnInit } from '@angular/core';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'login',
  imports: [],
  template: `
    <div class="flex flex-col items-center justify-center h-screen">
      <h1 class="text-4xl font-bold mb-8">Bem-vindo ao Bolão da Copa!</h1>
      <button
        class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors"
      >
        Entrar com Google
      </button>
    </div>
  `,
})
export class LoginPage implements OnInit {
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    // TODO
    // this.authService.login();
  }
}
