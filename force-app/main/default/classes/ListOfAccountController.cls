public with sharing class ListOfAccountController {
  @AuraEnabled(cacheable=true)
  public static List<Account> getAccountList() {
    return [
      SELECT
        Id,
        Name,
        Phone,
        Total_Opportunity_Amount__c,
        Total_Opportunity_Count__c
      FROM Account
      LIMIT 12
    ];
  }
}
