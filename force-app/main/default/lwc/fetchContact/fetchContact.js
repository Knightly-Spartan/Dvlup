import { LightningElement, wire, track } from 'lwc';
import Id from '@salesforce/user/Id';
import { getRecord } from 'lightning/uiRecordApi';

export default class FetchContact extends LightningElement {
    userId = Id;
    @track userName;
    @wire(getRecord, { recordId: '$userId', fields: ['User.Name'] })
    wiredRecord({ error, data }) {
        {
            if (data) {
                // eslint-disable-next-line no-debugger
                debugger;
                this.userName = data.fields.Name.value;
            } else if (error) {
                window.console.log(error.body.message);
            }
        }
    }
}