trigger OpportunityTrigger on Opportunity(before insert,after insert,before update,
                                          after update,after delete,after undelete) {
  if (Trigger.isAfter) {
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        OpportunityTriggerHandler.handleOpportunityChanges(Trigger.new, Trigger.oldMap);
    }
    if (Trigger.isUpdate) {
        // Handle the case where the Opportunity's AccountId is changed
        Set<Id> oldAccountIds = new Set<Id>();
        for (Opportunity opp : Trigger.old) {
            oldAccountIds.add(opp.AccountId);
        }

        Set<Id> newAccountIds = new Set<Id>();
        for (Opportunity opp : Trigger.new) {
            newAccountIds.add(opp.AccountId);
        }

        Set<Id> affectedAccountIds = new Set<Id>(oldAccountIds);
        affectedAccountIds.addAll(newAccountIds);

        OpportunityTriggerHandler.handleAccountChange(affectedAccountIds);
    }

    if (Trigger.isDelete) {
        Set<Id> deletedAccountIds = new Set<Id>();
        for (Opportunity opp : Trigger.old) {
            deletedAccountIds.add(opp.AccountId);
        }

        OpportunityTriggerHandler.handleAccountChange(deletedAccountIds);
    }
}
}


