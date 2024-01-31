import { LightningElement, wire } from "lwc";
import getAcc from "@salesforce/apex/ListOfAccountController.getAccountList";

const columns = [
  { label: "Account Name", fieldName: "Name" },
  { label: "Phone", fieldName: "Phone" },
  {
    label: "Total Opportunity Amount",
    fieldName: "Total_Opportunity_Amount__c"
  },
  { label: "Total Opportunity Count", fieldName: "Total_Opportunity_Count__c" }
];

export default class ListOfAccounts extends LightningElement {
  data = [];
  columns = columns;

  @wire(getAcc)
  wiredAccounts(result) {
    if (result.data) {
      this.data = result.data;
    } else if (result.error) {
      console.error("Error", result.error);
    }
  }
}


