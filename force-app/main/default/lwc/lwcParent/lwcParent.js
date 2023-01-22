import { LightningElement, track } from 'lwc';

export default class LwcParent extends LightningElement {
    @track grettingvalue = 'World';

    handleChange(event) {
        this.grettingvalue = event.target.value;
    }
}