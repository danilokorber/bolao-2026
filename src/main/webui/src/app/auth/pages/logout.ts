import { Component, inject, OnInit } from '@angular/core';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'logout',
  imports: [],
  template: ` LOGOUT `,
})
export class LogoutPage implements OnInit {
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    // TODO
    // this.authService.logout();
  }
}
