import { Routes } from '@angular/router';
import { CleanLayout } from '../layout/clean-layout';
import { Dashboard } from '../pages/dashboard';
import { Matches } from '../pages/matches';

export const routes: Routes = [
  {
    path: '',
    component: CleanLayout,
    children: [
      { path: '', component: Dashboard, title: 'Bolão da Copa' },
      { path: 'matches', component: Matches, title: 'Bolão da Copa' },
    ],
  },
];
