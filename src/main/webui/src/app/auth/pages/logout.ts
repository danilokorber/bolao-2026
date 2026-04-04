import { Component, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '@auth/services/auth.service';

@Component({
  selector: 'logout',
  imports: [],
  template: `
    <div class="flex flex-col gap-4">
      <img src="/fifawc2026.png" />
    </div>
  `,
})
export class LogoutPage implements OnInit {
  private readonly route = inject(Router);
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    this.authService.logout();
    this.route.navigate(['login']);
  }
}
