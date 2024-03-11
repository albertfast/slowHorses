// JavaScript
import { LightningElement, wire } from 'lwc';
import getAcc from '@salesforce/apex/ListOfAccountController.getAccountList';

const columns = [
  { label: 'Account Name', fieldName: 'Name' },
  { label: 'Phone', fieldName: 'Phone' },
  {
    label: 'Total Opportunity Amount',
    fieldName: 'Total_Opportunity_Amount__c'
  },
  { label: 'Total Opportunity Count', fieldName: 'Total_Opportunity_Count__c' }
];

export default class ListOfAccounts extends LightningElement {
  data = [];
  columns = columns;
  isPanelVisible = true;

  @wire(getAcc)
  wiredAccounts(result) {
    if (result.data) {
      this.data = result.data;
    } else if (result.error) {
      console.error('Error', result.error);
      // Handle the error as needed
    }
  }

  connectedCallback() {
    this.hidePanel1();
    console.log('ConnectedCallBack is called...');
  }
  
  showPanel1() {
    this.isPanelVisible = true;
    const panel = this.template.querySelector('.panel1');
    if (panel) {
        setTimeout(() => {
            panel.classList.add('show');
            panel.classList.remove('hide');
        }, 0);
    }
  }
  
  hidePanel1() {
    this.isPanelVisible = false;
    const panel = this.template.querySelector('.panel1');
    if (panel) {
        panel.classList.add('hide');
        panel.classList.remove('show');
    }
  
    // Show the panel after 5 seconds
    setTimeout(() => {
        this.showPanel1();
    }, 5000);
  }
} 




/*
import { LightningElement, wire } from 'lwc';
import getAcc from '@salesforce/apex/ListOfAccountController.getAccountList';

const columns = [
  { label: 'Account Name', fieldName: 'Name' },
  { label: 'Phone', fieldName: 'Phone' },
  {
    label: 'Total Opportunity Amount',
    fieldName: 'Total_Opportunity_Amount__c'
  },
  { label: 'Total Opportunity Count', fieldName: 'Total_Opportunity_Count__c' }
];

export default class ListOfAccounts extends LightningElement {
  data = [];
  columns = columns;
  isPanelVisible = true;

  @wire(getAcc)
  wiredAccounts(result) {
    if (result.data) {
      this.data = result.data;
    } else if (result.error) {
      console.error('Error', result.error);
      // Handle the error as needed
    }
  }

  connectedCallback() {
    // Start the cycle when the component is connected to the DOM
    this.hidePanel1();
  }

  showPanel1() {
    this.isPanelVisible = true;
    const panel = this.template.querySelector('.panel');
    if (panel) {
      panel.classList.remove('hide');
      panel.classList.add('show');
    }
  }

  hidePanel1() {
    this.isPanelVisible = false;
    const panel = this.template.querySelector('.panel');
    if (panel) {
      panel.classList.remove('show');
      panel.classList.add('hide');
    }

    // Show the panel after 3 seconds
    setTimeout(() => {
      console.log('Hiding panel1.');
      this.hidePanel1();
      // Show the panel after 3 seconds
      setTimeout(() => {
          console.log('Showing panel1.');
          this.showPanel1();
          // Continue the cycle
          this.hideAfterDelay();
      }, 1000);
    }, 2300); // Hide after 4 seconds
}
} */