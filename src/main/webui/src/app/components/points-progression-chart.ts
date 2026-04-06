import { Component, computed, inject, input } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { AgCharts } from 'ag-charts-angular';
import { AgChartOptions } from 'ag-charts-community';
import { RankingEntry } from '@interfaces/ranking-entry.interface';

export interface HistoryEntry {
  matchday: string;
  userId: string;
  userName: string;
  cumulativePoints: number;
}

const CHART_COLORS = ['#0d6537', '#e9a820', '#f97316', '#3b82f6', '#9333ea', '#dc2626'];

@Component({
  selector: 'points-progression-chart',
  imports: [AgCharts],
  template: `
    <ag-charts
      style="display: block; height: 200px; width: 100%;"
      [options]="chartOptions()"
    ></ag-charts>
  `,
})
export class PointsProgressionChart {
  private readonly transloco = inject(TranslocoService);

  users = input.required<RankingEntry[]>();
  history = input.required<HistoryEntry[]>();
  currentUserId = input<string>();

  chartOptions = computed<AgChartOptions>(() => {
    const users = this.users();
    const historyData = this.history();
    if (!users.length || !historyData.length) return { data: [] };

    const today = new Date().toISOString().slice(0, 10);
    const matchdays = [...new Set(historyData.map((h) => h.matchday))]
      .sort()
      .filter((d) => d <= today);

    const data = matchdays.map((day) => {
      const row: Record<string, unknown> = { matchday: this.formatMatchday(day) };
      for (const user of users) {
        const entry = historyData.find((h) => h.matchday === day && h.userId === user.userId);
        row[user.userId] = entry?.cumulativePoints ?? null;
      }
      return row;
    });

    // Fill forward nulls
    for (const user of users) {
      let last: number | null = null;
      for (const row of data) {
        if (row[user.userId] !== null) {
          last = row[user.userId] as number;
        } else if (last !== null) {
          row[user.userId] = last;
        }
      }
    }

    // Compute Y-axis bounds rounded to nearest 50
    let allValues: number[] = [];
    for (const row of data) {
      for (const user of users) {
        const v = row[user.userId];
        if (typeof v === 'number') allValues.push(v);
      }
    }
    const minVal = Math.floor(Math.min(...allValues) / 50) * 50;
    const maxVal = Math.ceil(Math.max(...allValues) / 50) * 50;
    const safeMax = maxVal <= minVal ? minVal + 50 : maxVal;

    return {
      data,
      background: { fill: 'transparent' },
      series: users.map((u, i) => ({
        type: 'line' as const,
        xKey: 'matchday',
        yKey: u.userId,
        yName: u.userName,
        stroke: CHART_COLORS[i % CHART_COLORS.length],
        marker: { enabled: false },
        strokeWidth: u.userId === this.currentUserId() ? 3 : 1.5,
      })),
      axes: [
        {
          type: 'category' as const,
          position: 'bottom' as const,
          label: { enabled: false, rotation: -45, fontSize: 11 },
        },
        {
          type: 'number' as const,
          position: 'left' as const,
          preferredMin: minVal,
          preferredMax: safeMax,
          label: { fontSize: 11 },
          nice: false,
        },
      ],
      legend: { enabled: false, position: 'bottom' as const, item: { label: { fontSize: 12 } } },
      height: 200,
    };
  });

  private formatMatchday(iso: string): string {
    const d = new Date(iso + 'T12:00:00');
    return d.toLocaleDateString(this.transloco.getActiveLang(), { day: '2-digit', month: 'short' });
  }
}
