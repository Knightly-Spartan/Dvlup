import { LightningElement, api } from 'lwc';

export default class MyFirstWebComponent extends LightningElement {
    @api greeting = 'Welcome to my first web component';
}