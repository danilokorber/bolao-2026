import { computed, inject } from '@angular/core';
import {
  patchState,
  signalStore,
  withComputed,
  withHooks,
  withMethods,
  withState,
} from '@ngrx/signals';
import { SignalStoreService } from './signal-store.service';
import { AppUser } from '@interfaces/index';

export const SignalStore = signalStore(
  { providedIn: 'root' },
  withState({
    appuser: undefined as AppUser | undefined,
  }),

  withMethods((store) => {
    const signalStoreService = inject(SignalStoreService);

    return {
      async loadAppUser() {
        const appUser = await signalStoreService.setOrGetProfile();
        patchState(store, { appuser: appUser });
      },

      // async updateStep(step: IStep) {
      //   const updatedStep = await signalStoreService.putStep(step);
      //   patchState(store, {
      //     steps: store.steps().map((s) => (s.id === updatedStep.id ? updatedStep : s)),
      //   });
      // },

      getAppUser() {
        return computed(() => store.appuser() ?? this.loadAppUser());
      },
    };
  }),

  withHooks({
    onInit({ loadAppUser }) {
      loadAppUser();
    },
    onDestroy() {
      console.log('on destroy');
    },
  }),

  withComputed(({ appuser }) => ({
    appuser: computed(() => appuser()),
  })),
);
