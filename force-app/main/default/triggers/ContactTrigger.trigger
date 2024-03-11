/*
Contact & Account has a field called IsActive, if contact is marked as inactive, 
validate corresponding account and if all contacts now under that account are marked as inactive 
-need to update account and mark it as inactive as well.
*/
trigger ContactTrigger on Contact (after insert, after update) {
    // Trigger ContactTrigger runs after any update or insert operation on the Contact object.

    // Here the trigger operations are defined.
    Set<Id> updatedAccountIds = new Set<Id>(); // A Set is created to store updated Account IDs.

    // A loop is created to iterate over all contacts that are inserted or updated.
    for (Contact con : Trigger.new) {
        // For each contact, the operation is performed.

        // The status of the related Account is checked.
        if (!con.IsActive__c) { // If the contact is inactive (IsActive__c field is false),
            // The status of all contacts under the related Account is checked.
            Boolean allContactsInactive = [SELECT COUNT() FROM Contact WHERE AccountId = :con.AccountId AND IsActive__c = true] == 0;
            // If there are no active contacts in the related Account,
            if (allContactsInactive) {
                // The status of the Account is updated.
                updatedAccountIds.add(con.AccountId); // Updated Account IDs are added to the set.
            }
        }
    }

    // Update the updated Accounts.
    List<Account> accountsToUpdate = [SELECT Id, Active__c FROM Account WHERE Id IN :updatedAccountIds];
    for (Account acc : accountsToUpdate) {
        acc.Active__c = 'No'; // Account going to be InActive
    }

    // Save the updated Accounts.
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}


/*
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
}  */