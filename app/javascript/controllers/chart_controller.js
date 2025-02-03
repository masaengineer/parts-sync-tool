import { Controller } from '@hotwired/stimulus';
import ApexCharts from 'apexcharts';

export default class extends Controller {
  static targets = ['chart'];

  connect() {
    const dataElement = this.element.closest('[data-chart-data]');
    const chartData = dataElement
      ? JSON.parse(dataElement.dataset.chartData)
      : null;
    console.log('Chart Data:', chartData);

    const options = {
      chart: {
        type: 'line',
        height: 350,
        zoom: {
          enabled: false,
        },
      },
      series: chartData ? chartData.series : [],
      xaxis: {
        categories: chartData ? chartData.categories : [],
      },
      yaxis: {
        labels: {
          formatter: function (value) {
            return '¥' + value.toLocaleString();
          },
        },
      },
      tooltip: {
        y: {
          formatter: function (value) {
            return '¥' + value.toLocaleString();
          },
        },
      },
    };

    this.chart = new ApexCharts(this.chartTarget, options);
    this.chart.render();
  }

  disconnect() {
    this.chart.destroy();
  }
}
