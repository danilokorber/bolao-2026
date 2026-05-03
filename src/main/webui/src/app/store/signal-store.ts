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
    currentPoolId: undefined as string | undefined,
  }),

  withMethods((store) => {
    const signalStoreService = inject(SignalStoreService);

    return {
      async loadAppUser() {
        const appUser = await signalStoreService.setOrGetProfile();
        patchState(store, { appuser: appUser });

        if (appUser?.id) {
          const poolId = await signalStoreService.getFirstActivePoolId(appUser.id);
          patchState(store, { currentPoolId: poolId });
        }
      },

      getAppUser() {
        return computed(() => store.appuser() ?? this.loadAppUser());
      },

      setCurrentPoolId(id: string) {
        patchState(store, { currentPoolId: id });
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

  withComputed(({ appuser, currentPoolId }) => ({
    appuser: computed(() => appuser()),
    currentPoolId: computed(() => currentPoolId()),
  })),
);
