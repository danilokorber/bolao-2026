import { Currency } from './currency.enum';

export interface Pool {
  id?: string;
  name: string;
  description?: string;
  entryFee: number;
  currency: Currency;
  createdAt?: string;
  isActive?: boolean;
  inviteCode: string;
}
