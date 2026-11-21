/*
 * Capsule – login heatmap grid utilities.
 *
 * Originally lived in the CLI module; relocated here so the user-settings
 * LoginHeatmap component can import it without depending on the (removed)
 * CLI feature.
 */

/** Short month-name keys used for i18n lookups. */
export const HEATMAP_MONTH_KEYS: readonly string[] = [
  'jan', 'feb', 'mar', 'apr', 'may', 'jun',
  'jul', 'aug', 'sep', 'oct', 'nov', 'dec',
];

/** A single day cell in the heatmap. */
export interface HeatmapCell {
  /** Date key in `YYYY-MM-DD` format. */
  key: string;
  /** Human-readable label for the date (same as `key`). */
  label: string;
  /** Activity count for this day (provided by the caller). */
  count: number;
  /** Whether this day is in the future. */
  future: boolean;
  /** Whether this day is today. */
  isToday: boolean;
}

/** A single month block in the heatmap. */
export interface HeatmapMonth {
  /** Unique key for the month (`YYYY-MM`). */
  key: string;
  /** Zero-based month index (0 = January). */
  month: number;
  /** Column offset within the month block (number of days before the first
   *  day of the month, used to align the weekday rows). */
  offset: number;
  /** Array of day cells for this month. */
  cells: HeatmapCell[];
}

/** Return type of {@link buildHeatmapMonths}. */
export interface HeatmapData {
  months: HeatmapMonth[];
}

/**
 * Build a 12-month heatmap grid ending at the current month.
 *
 * @param countFn – Called with a date key (`YYYY-MM-DD`) and returns
 *   the numeric count for that day.
 * @returns An object containing the array of months with their cells.
 */
export function buildHeatmapMonths(
  countFn: (dateKey: string) => number,
): HeatmapData {
  const today = new Date();
  const todayKey = formatDateKey(today);
  const months: HeatmapMonth[] = [];

  for (let i = 11; i >= 0; i--) {
    const d = new Date(today.getFullYear(), today.getMonth() - i, 1);
    const year = d.getFullYear();
    const month = d.getMonth();
    const monthKey = `${year}-${String(month + 1).padStart(2, '0')}`;
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    // Sunday = 0 in JS; we use Monday-first (Mon=0 … Sun=6).
    const firstDayOfWeek = (d.getDay() + 6) % 7;

    const cells: HeatmapCell[] = [];
    for (let day = 1; day <= daysInMonth; day++) {
      const cellDate = new Date(year, month, day);
      const key = formatDateKey(cellDate);
      const future = cellDate > today;
      cells.push({
        key,
        label: key,
        count: future ? 0 : countFn(key),
        future,
        isToday: key === todayKey,
      });
    }

    months.push({ key: monthKey, month, offset: firstDayOfWeek, cells });
  }

  return { months };
}

/** Format a Date as `YYYY-MM-DD`. */
function formatDateKey(d: Date): string {
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${y}-${m}-${day}`;
}
