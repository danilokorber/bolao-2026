export interface AppUser {
  id?: string;
  keycloakId: string;
  name: string;
  email: string;
  createdAt?: string;
  active?: boolean;
}
