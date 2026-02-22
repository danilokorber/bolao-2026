import { Component, inject, OnInit } from '@angular/core';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'post-logout',
  imports: [],
  template: ` POST LOGOUT `,
})
export class PostLogoutPage implements OnInit {
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    // TODO
  }
}
