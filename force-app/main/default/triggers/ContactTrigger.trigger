trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete, Before update ) {
  if (Trigger.isBefore && trigger.isUpdate) {
    if (Trigger.isUpdate) {
      ContactTriggerHandler.updatePhoneSecondVersion(Trigger.new, Trigger.oldMap);
      ContactTriggerHandler.cannotChangeAccountOwner(Trigger.new, Trigger.oldMap);
      ContactTriggerHandler.cantUpdatePhone(Trigger.new, Trigger.oldMap);
    }
  }  
  
  if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            ContactTriggerHandler.handleAfterInsertUpdate(Trigger.new, Trigger.oldMap);
            
        }
        if (Trigger.isUpdate) {
          // Handle the case where the Contact's AccountId is changed  
          Set<Id> oldAccountIds = new Set<Id>();
          for (Contact con : Trigger.old) {
            oldAccountIds.add(con.AccountId);
          }
          Set<Id> newAccountIds = new Set<Id>();
          for (Contact con : Trigger.new) {
            newAccountIds.add(con.AccountId);
          }
          Set<Id> affectedAccountIds = new Set<Id>(oldAccountIds);
          affectedAccountIds.addAll(newAccountIds);
          ContactTriggerHandler.handleAccountChange(affectedAccountIds);

        } 
        if (Trigger.isDelete) {
            Set<Id> deletedAccountIds = new Set<Id>();
            for (Contact con : Trigger.old) {
                deletedAccountIds.add(con.AccountId);
            }
            ContactTriggerHandler.handleAccountChange(deletedAccountIds);
        } 
    } 
}


