import { Routes } from '@angular/router';
import { LoginPage } from '@auth/pages/login';
import { LogoutPage } from '@auth/pages/logout';
import { PostLoginPage } from '@auth/pages/post-login';
import { PostLogoutPage } from '@auth/pages/post-logout';
import { FullPageLayout } from '@layout/full-page';

export default [
  {
    path: '',
    component: FullPageLayout,
    children: [
      {
        path: 'login',
        component: LoginPage,
        pathMatch: 'full',
      },
      {
        path: 'post-login',
        component: PostLoginPage,
        pathMatch: 'full',
        // Note: post-login doesn't need guestGuard as it handles the transition
      },
      {
        path: 'logout',
        component: LogoutPage,
        pathMatch: 'full',
      },
      {
        path: 'post-logout',
        component: PostLogoutPage,
        pathMatch: 'full',
      },
      // {
      //   path: 'first-login',
      //   component: FirstLoginPage,
      //   pathMatch: 'full',
      // },
      // Default redirect to login for auth routes
      {
        path: '',
        redirectTo: '/login',
        pathMatch: 'full',
      },
    ],
  },
] as Routes;
