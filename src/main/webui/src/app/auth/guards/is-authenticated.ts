import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';

export const isAuthenticated: CanActivateFn = (route, state) => {
  const authService = inject(AuthService);
  const router = inject(Router);

  sessionStorage.setItem('redirectUrl', state.url);

  if (authService.isNotLoggedIn()) {
    router.navigate(['/login']);
    return false;
  }
  return true;
};
