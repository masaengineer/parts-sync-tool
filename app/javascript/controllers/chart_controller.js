import { Controller } from '@hotwired/stimulus';
import ApexCharts from 'apexcharts';

export default class extends Controller {
  static targets = ['chart'];

  connect() {
    if (!this.hasChartTarget) return;

    const chartData = JSON.parse(
      this.element.closest('[data-chart-data]').dataset.chartData
    );

    const options = {
      chart: {
        type: 'line',
        height: 350,
        toolbar: {
          show: true,
        },
      },
      series: chartData.series,
      xaxis: {
        categories: chartData.categories,
      },
      stroke: {
        curve: 'smooth',
        width: 2,
      },
      markers: {
        size: 4,
      },
      tooltip: {
        y: {
          formatter: function (value) {
            return new Intl.NumberFormat('ja-JP', {
              style: 'currency',
              currency: 'JPY',
              maximumFractionDigits: 0,
            }).format(value);
          },
        },
      },
    };

    this.chart = new ApexCharts(this.chartTarget, options);
    this.chart.render();
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy();
    }
  }
}
