import { LightningElement, api } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import chartjs from '@salesforce/resourceUrl/chartjs';

export default class TransactionChart extends LightningElement {
    chart;
    chartjsInitialized = false;
    _privateData;

    @api
    get chartData() {
        return this._privateData;
    }
    set chartData(value) {
        this._privateData = value;
        if (this.chartjsInitialized) {
            this.chart.config.data.datasets[0].data = [...value];
            this.chart.update();
        }
    }

    config = {
        type: 'doughnut',
        data: {
            datasets: [
                {
                    data: this._privateData,
                    backgroundColor: ['rgb(75, 192, 192)', 'rgb(255, 99, 132)'],
                    label: 'Dataset 1'
                }
            ],
            labels: ['Total Income', 'Total Expense']
        },
        options: {
            responsive: false,
            animation: {
                animateScale: true,
                animateRotate: true
            }
        }
    };

    async renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;

        try {
            await loadScript(this, chartjs);
            const canvas = document.createElement('canvas');
            this.template.querySelector('div.chart').appendChild(canvas);
            const ctx = canvas.getContext('2d');
            this.chart = new window.Chart(ctx, this.config);
        } catch (error) {
            this.error = error;
        }
    }
}