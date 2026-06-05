import { Routes } from '@angular/router';
import { isAuthenticated } from '@auth/guards/is-authenticated';
import { NavigationLayout } from '@layout/navigation-layout';
import { CleanLayout } from '../layout/clean-layout';
import { Account } from '../pages/account';
import { ChampionBetPage } from '../pages/champion-bet';
import { Dashboard } from '../pages/dashboard';
import { GroupWinnerBets } from '../pages/group-winner-bets';
import { MatchDetail } from '../pages/match-detail';
import { Matches } from '../pages/matches';
import { PoolsPage } from '../pages/pools';
import { Privacy } from '../pages/privacy';
import { RankingPage } from '../pages/ranking';
import { UserBetsPage } from '../pages/user-bets';

export const routes: Routes = [
  // Public routes (authentication pages)
  {
    path: '',
    loadChildren: () => import('@auth/routes/auth.routes'),
  },
  { path: 'privacy', component: Privacy, title: 'Bolão da Copa', pathMatch: 'full' },
  // Post login routes (require authentication)
  {
    path: '',
    component: CleanLayout,
    canActivate: [isAuthenticated],
    children: [
      { path: 'group-bets', component: GroupWinnerBets, title: 'Bolão da Copa' },
      { path: 'champion-bet', component: ChampionBetPage, title: 'Bolão da Copa' },
    ],
  },

  // Protected routes (require authentication)
  {
    path: '',
    component: NavigationLayout,
    canActivate: [isAuthenticated],
    children: [
      { path: '', component: Dashboard, title: 'Bolão da Copa' },
      { path: 'dashboard', component: Dashboard, title: 'Bolão da Copa' },
      { path: 'matches', component: Matches, title: 'Bolão da Copa' },
      { path: 'matches/:id', component: MatchDetail, title: 'Bolão da Copa' },
      { path: 'ranking', component: RankingPage, title: 'Bolão da Copa' },
      { path: 'pools', component: PoolsPage, title: 'Bolão da Copa' },
      { path: 'bets/:userId', component: UserBetsPage, title: 'Bolão da Copa' },
      { path: 'account', component: Account, title: 'Bolão da Copa' },
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
