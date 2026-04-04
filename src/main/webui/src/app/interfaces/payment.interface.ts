import { Currency } from './currency.enum';
import { PaymentMethod } from './payment-method.enum';
import { PaymentStatus } from './payment-status.enum';
import { AppUser } from './app-user.interface';
import { Pool } from './pool.interface';

export interface Payment {
  id?: string;
  userId: string;
  poolId: string;
  user?: AppUser;
  pool?: Pool;
  amount: number;
  currency: Currency;
  paymentMethod: PaymentMethod;
  status: PaymentStatus;
  transactionId?: string;
  paidAt?: string;
  confirmedAt?: string;
}
