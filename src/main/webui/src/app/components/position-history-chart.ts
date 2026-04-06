import { Component, computed, inject, input } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { AgCharts } from 'ag-charts-angular';
import { AgChartOptions } from 'ag-charts-community';
import { RankingEntry } from '@interfaces/ranking-entry.interface';
import { HistoryEntry } from './points-progression-chart';

const CHART_COLORS = ['#0d6537', '#e9a820', '#f97316', '#3b82f6', '#9333ea', '#dc2626'];

@Component({
  selector: 'position-history-chart',
  imports: [AgCharts],
  template: `
    <ag-charts
      style="display: block; height: 200px; width: 100%;"
      [options]="chartOptions()"
    ></ag-charts>
  `,
})
export class PositionHistoryChart {
  private readonly transloco = inject(TranslocoService);

  users = input.required<RankingEntry[]>();
  history = input.required<HistoryEntry[]>();
  currentUserId = input<string>();

  chartOptions = computed<AgChartOptions>(() => {
    const users = this.users();
    const historyData = this.history();
    if (!users.length || !historyData.length) return { data: [] };

    const allUsers = [...new Set(historyData.map((h) => h.userId))];
    const today = new Date().toISOString().slice(0, 10);
    const matchdays = [...new Set(historyData.map((h) => h.matchday))]
      .sort()
      .filter((d) => d <= today);

    // Build cumulative map for ALL users to compute positions correctly
    const cumulativeMap = new Map<string, Map<string, number>>();
    for (const day of matchdays) {
      cumulativeMap.set(day, new Map());
    }
    for (const entry of historyData) {
      const dayMap = cumulativeMap.get(entry.matchday);
      if (dayMap) dayMap.set(entry.userId, entry.cumulativePoints);
    }

    // Fill forward for all users
    for (const uid of allUsers) {
      let last = 0;
      for (const day of matchdays) {
        const dayMap = cumulativeMap.get(day)!;
        if (dayMap.has(uid)) {
          last = dayMap.get(uid)!;
        } else {
          dayMap.set(uid, last);
        }
      }
    }

    // Compute positions per matchday (negated so rank 1 appears at top)
    const data = matchdays.map((day) => {
      const dayMap = cumulativeMap.get(day)!;
      const sorted = [...dayMap.entries()].sort((a, b) => b[1] - a[1]);
      const row: Record<string, unknown> = { matchday: this.formatMatchday(day) };
      for (const user of users) {
        const pos = sorted.findIndex(([uid]) => uid === user.userId) + 1;
        row[user.userId] = pos > 0 ? -pos : null;
      }
      return row;
    });

    const totalUsers = allUsers.length;

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
        tooltip: {
          renderer: (params: any) => ({
            content: `${params.yName}: #${Math.abs(params.yValue)}`,
            title: params.xValue,
          }),
        },
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
          min: -totalUsers,
          max: -1,
          nice: false,
          label: {
            fontSize: 11,
            formatter: (params: { value: number }) => String(Math.abs(params.value)),
          },
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
