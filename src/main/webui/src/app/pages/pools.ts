import { HttpClient } from '@angular/common/http';
import { httpResource } from '@angular/common/http';
import { Component, computed, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { TranslocoPipe } from '@jsverse/transloco';
import { API } from '@api/api';
import { SaveIndicator } from '@components/save-indicator';
import { SaveState } from '@services/bet-save.service';
import {
  Payment,
  PaymentMethod,
  PaymentStatus,
  Pool,
  UserPool,
  UserPoolStatus,
} from '@interfaces/index';
import { SAVE_FEEDBACK_DURATION_MS } from '@utils/constants';
import { SignalStore } from '../store/signal-store';

@Component({
  selector: 'pools-page',
  standalone: true,
  imports: [TranslocoPipe, SaveIndicator, FormsModule],
  templateUrl: './pools.html',
})
export class PoolsPage {
  private readonly store = inject(SignalStore);
  private readonly http = inject(HttpClient);

  // Expose enums to template
  protected readonly UserPoolStatus = UserPoolStatus;
  protected readonly PaymentStatus = PaymentStatus;
  protected readonly PaymentMethod = PaymentMethod;

  // Core state
  userId = computed(() => this.store.appuser()?.id);
  currentPoolId = computed(() => this.store.currentPoolId());

  // Data loading
  userPools = httpResource<UserPool[]>(() => {
    const id = this.userId();
    return id ? API.USER_POOLS.GET_BY_USER(id) : undefined;
  });

  userPayments = httpResource<Payment[]>(() => {
    const id = this.userId();
    return id ? API.PAYMENTS.GET_BY_USER(id) : undefined;
  });

  // Computed: map poolId → Payment
  paymentsByPool = computed(() => {
    const payments = this.userPayments.value() ?? [];
    const map = new Map<string, Payment>();
    for (const p of payments) {
      map.set(p.poolId, p);
    }
    return map;
  });

  // Join flow state
  inviteCode = signal('');
  joinState = signal<'idle' | 'looking' | 'preview' | 'joining' | 'error'>('idle');
  previewPool = signal<Pool | null>(null);
  joinError = signal('');

  // Payment state
  payingPoolId = signal<string | null>(null);
  selectedPaymentMethod = signal<PaymentMethod>(PaymentMethod.PIX);
  transactionId = signal('');
  paymentSaveState: SaveState = { saving: false, saved: false };

  lookupPool(): void {
    const code = this.inviteCode().trim();
    if (!code) return;

    this.joinState.set('looking');
    this.joinError.set('');
    this.previewPool.set(null);

    this.http.get<Pool>(API.POOLS.GET_BY_INVITE_CODE(code)).subscribe({
      next: (pool) => {
        // Check if user already belongs to this pool
        const existing = this.userPools.value()?.find((up) => up.poolId === pool.id);
        if (existing) {
          this.joinState.set('error');
          this.joinError.set('pools.alreadyMember');
          return;
        }
        this.previewPool.set(pool);
        this.joinState.set('preview');
      },
      error: () => {
        this.joinState.set('error');
        this.joinError.set('pools.invalidCode');
      },
    });
  }

  joinPool(): void {
    const pool = this.previewPool();
    const uid = this.userId();
    if (!pool?.id || !uid) return;

    this.joinState.set('joining');

    this.http
      .post<UserPool>(API.USER_POOLS.CREATE(), {
        userId: uid,
        poolId: pool.id,
      })
      .subscribe({
        next: () => {
          this.joinState.set('idle');
          this.inviteCode.set('');
          this.previewPool.set(null);
          this.userPools.reload();
        },
        error: () => {
          this.joinState.set('error');
          this.joinError.set('pools.joinError');
        },
      });
  }

  cancelJoin(): void {
    this.joinState.set('idle');
    this.inviteCode.set('');
    this.previewPool.set(null);
    this.joinError.set('');
  }

  switchPool(poolId: string): void {
    this.store.setCurrentPoolId(poolId);
  }

  openPaymentForm(poolId: string): void {
    this.payingPoolId.set(poolId);
    this.selectedPaymentMethod.set(PaymentMethod.PIX);
    this.transactionId.set('');
  }

  closePaymentForm(): void {
    this.payingPoolId.set(null);
  }

  submitPayment(pool: Pool): void {
    const uid = this.userId();
    if (!uid || !pool.id) return;

    this.paymentSaveState.saving = true;
    this.paymentSaveState.saved = false;

    this.http
      .post<Payment>(API.PAYMENTS.CREATE(), {
        userId: uid,
        poolId: pool.id,
        amount: pool.entryFee,
        currency: pool.currency,
        paymentMethod: this.selectedPaymentMethod(),
        transactionId: this.transactionId().trim() || undefined,
      })
      .subscribe({
        next: () => {
          this.paymentSaveState.saving = false;
          this.paymentSaveState.saved = true;
          setTimeout(() => (this.paymentSaveState.saved = false), SAVE_FEEDBACK_DURATION_MS);
          this.payingPoolId.set(null);
          this.userPayments.reload();
        },
        error: () => {
          this.paymentSaveState.saving = false;
        },
      });
  }

  getPayment(poolId: string): Payment | undefined {
    return this.paymentsByPool().get(poolId);
  }
}
