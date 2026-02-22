import { Routes } from '@angular/router';
import { isAuthenticated } from '@auth/guards/is-authenticated';
import { CleanLayout } from '../layout/clean-layout';
import { Dashboard } from '../pages/dashboard';
import { Matches } from '../pages/matches';

export const routes: Routes = [
  // Public routes (authentication pages)
  {
    path: '',
    loadChildren: () => import('@auth/routes/auth.routes'),
  },

  // Protected routes (require authentication)
  {
    path: '',
    component: CleanLayout,
    canActivate: [isAuthenticated],
    children: [
      { path: '', component: Dashboard, title: 'Bolão da Copa' },
      { path: 'matches', component: Matches, title: 'Bolão da Copa' },
    ],
  },

  // Default redirects
  {
    path: '',
    redirectTo: '/dashboard',
    pathMatch: 'full',
  },

  // Catch-all route
  {
    path: '**',
    redirectTo: '/login',
  },
];
