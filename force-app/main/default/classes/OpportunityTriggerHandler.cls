// When a new opportunity is created, edited, deleted,
// or undeleted, or when the opportunity's account changes,
// Update the Total_Opportunity_Amount__c and Total_Opportunity_Count__c fields.
public with sharing class OpportunityTriggerHandler {
  private static Boolean isExecuting = false;
  public static void handleOpportunityChanges(
    List<Opportunity> newOpportunities,
     Map<Id, Opportunity> oldOpportunityMap) {
    if (!isExecuting) {
      isExecuting = true;
    Set<Id> accountIds = new Set<Id>();
    for (Opportunity opp : newOpportunities) {
        accountIds.add(opp.AccountId);
    }

    List<AggregateResult> countResults = [
        SELECT AccountId, COUNT(Id) opptCount
        FROM Opportunity 
        WHERE AccountId IN :accountIds
        GROUP BY AccountId
    ];

    List<AggregateResult> amountResults = [
        SELECT AccountId, SUM(Amount) oppAmount 
        FROM Opportunity 
        WHERE AccountId IN :accountIds
        AND StageName != 'Closed Won'
        GROUP BY AccountId
    ];

    List<Account> accountsToUpdate = new List<Account>();
    for (AggregateResult countResult : countResults) {
        Id accountId = (Id) countResult.get('AccountId');
        Integer count = (Integer) countResult.get('opptCount');

        Decimal amountSum = 0;
        for (AggregateResult amountResult : amountResults) {
            if ((Id) amountResult.get('AccountId') == accountId) {
                amountSum = (Decimal) amountResult.get('oppAmount');
                break;
            }
        }
        accountsToUpdate.add(new Account(
            Id = accountId,
            Total_Opportunity_Count__c = count,
            Total_Opportunity_Amount__c = amountSum
        ));
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }

    isExecuting = false;
        }
}
public static void handleAccountChange(Set<Id> affectedAccountIds) {
    List<Account> accountsToUpdate = new List<Account>();
    for (Id accountId : affectedAccountIds) {
        Integer totalCount = [SELECT COUNT() FROM Opportunity WHERE AccountId = :accountId];
        Decimal totalAmount = (Decimal) [
            SELECT SUM(Amount)
            FROM Opportunity 
            WHERE AccountId = :accountId AND StageName != 'Closed Won'
        ][0].get('expr0');

        accountsToUpdate.add(new Account(
            Id = accountId,
            Total_Opportunity_Count__c = totalCount,
            Total_Opportunity_Amount__c = totalAmount
        ));
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}
}


