import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/ListOfContactController.getContactList';


export default class ListOfContact extends LightningElement {
    @wire(getContactList) contacts;
}

