import { Component, inject, OnInit } from '@angular/core';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'post-login',
  imports: [],
  template: ` POST LOGIN `,
})
export class PostLoginPage implements OnInit {
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    // TODO
  }
}
