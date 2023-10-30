import { LightningElement, track, api, wire } from 'lwc';
import getTransactionTotals from '@salesforce/apex/TransactionController.getTransactionTotals';

export default class AccountTransactions extends LightningElement {
    @api recordId;
    error;
    totalIncome = 0;
    totalExpense = 0;
    selectedQuantity = 1;
    selectedTimeframe = 'Days';
    @track chartData = [0,0];

    @wire(getTransactionTotals, {
        accountId: '$recordId',
        selectedTimeframe: '$selectedTimeframe',
        selectedQuantity: '$selectedQuantity'
    })
    wiredGetTransactionTotals({ error, data }) {
        if (data) {
            this.totalIncome = data.TotalIncome ? data.TotalIncome : 0;
            this.totalExpense = data.TotalExpense ? data.TotalExpense : 0;
            this.chartData = [this.totalIncome, this.totalExpense];
            this.error = undefined;
        } else if (error) {
            this.error = 'Error retrieving totals';
            this.totalIncome = 0;
            this.totalExpense = 0;
        }
    }

    handleTimeframeSelection(event) {
        this.selectedTimeframe = event.detail;
    }

    handleQuantitySelection(event) {
        this.selectedQuantity = event.detail;
    }
}
