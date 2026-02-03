import { GroupName } from './group-name.enum';

export interface Team {
  id?: string;
  nameEn: string;
  nameDe: string;
  namePt: string;
  fifaCode: string;
  flagUrl?: string;
  groupName?: GroupName;
}
