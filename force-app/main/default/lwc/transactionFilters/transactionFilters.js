import { LightningElement, api } from 'lwc';

export default class TransactionFilters extends LightningElement {
    @api selectedQuantity;
    @api selectedTimeframe;
    timeframes = [
        { label: 'Days', value: 'Days' },
        { label: 'Weeks', value: 'Weeks' },
        { label: 'Months', value: 'Months' },
        { label: 'Years', value: 'Years' }
    ];
    daysOptions = [];
    weeksOptions = [];
    monthsOptions = [];
    yearsOptions = [];

    connectedCallback() {
        for (let i = 1; i <= 60; i++) {
            this.daysOptions.push({ label: `${i}`, value: i });
        }
        for (let i = 1; i <= 12; i++) {
            this.weeksOptions.push({ label: `${i}`, value: i });
            this.monthsOptions.push({ label: `${i}`, value: i });
        }
        for (let i = 1; i <= 3; i++) {
            this.yearsOptions.push({ label: `${i}`, value: i });
        }
    }

    get isTimeframe() {
        return {
            Days: this.selectedTimeframe === 'Days',
            Weeks: this.selectedTimeframe === 'Weeks',
            Months: this.selectedTimeframe === 'Months',
            Years: this.selectedTimeframe === 'Years'
        };
    }

    handleTimeframeSelection(event) {
        this.selectedTimeframe = event.detail.value;
        this.dispatchEvent(new CustomEvent('timeframeselect', { detail: this.selectedTimeframe }));
    }

    handleQuantitySelection(event) {
        this.selectedQuantity = +event.detail.value;
        this.dispatchEvent(new CustomEvent('quantityselect', { detail: this.selectedQuantity }));
    }
}
