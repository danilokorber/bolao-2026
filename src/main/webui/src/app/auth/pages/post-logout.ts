import { Component, inject, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { TranslocoPipe } from '@jsverse/transloco';
import { AuthService } from '../services/auth.service';

@Component({
  selector: 'post-logout',
  imports: [TranslocoPipe],
  template: `<span>{{ 'postLogout.message' | transloco }}</span>`,
})
export class PostLogoutPage implements OnInit {
  private readonly router = inject(Router);
  private readonly authService = inject(AuthService);

  ngOnInit(): void {
    this.router.navigate(['login']);
  }
}
