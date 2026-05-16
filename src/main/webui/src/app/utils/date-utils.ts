/**
 * Ensures a datetime string from the backend is interpreted as UTC.
 *
 * The backend stores match times in UTC but may serialize them as
 * `"2026-06-11T20:00:00"` (no timezone indicator). JavaScript's
 * `new Date("2026-06-11T20:00:00")` treats that as *local* time,
 * so the value silently shifts. Appending `"Z"` forces UTC
 * interpretation and lets `DatePipe` / `toLocaleString` convert
 * to the user's local timezone automatically.
 */
export function utcDate(dt: string): Date {
  if (!dt) return new Date(0);
  return dt.endsWith('Z') || /[+-]\d{2}:\d{2}$/.test(dt)
    ? new Date(dt)
    : new Date(dt + 'Z');
}
