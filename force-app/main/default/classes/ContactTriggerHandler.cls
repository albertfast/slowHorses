/*
“I have a custom checkbox field Is_Primary__c in the Contact object, 
and a custom field CountOfPrimaryContacts__c in the Account object. 
I would like to increment or decrement the CountOfPrimaryContacts__c field on the Account object
whenever a Contact is created,updated,deleted or Account changed with Is_Primary__c set to true.
Could you guide me on how to achieve this functionality?”
*/
public with sharing class ContactTriggerHandler {
    private static Boolean isExecuting = false;

    public static void handleAfterInsertUpdate(List<Contact> newContacts, Map<Id,Contact> oldMap) {
        if (!isExecuting) {
            isExecuting = true;
            //Collect all account Ids from the contacts
            Set<Id> accIds = new Set<Id>();
            for (Contact con : newContacts) {
                accIds.add(con.AccountId);
            }
            List<AggregateResult> countResults = [
            SELECT AccountId, COUNT(Id) conCount
            FROM Contact
            WHERE AccountId IN: accIds
            AND Is_Primary__c = true
            GROUP BY AccountId
            ];

            List<Account> accountToUpdate = new List<Account>();
            for (AggregateResult countResult : countResults) {
                Id accountId = (Id) countResult.get('AccountId');
                Integer count = (Integer) countResult.get('conCount');

                accountToUpdate.add(new Account(
                    Id = accountId,
                    CountOfPrimaryContacts__c = count
                ));
            }
            if (!accountToUpdate.isEmpty()) {
                update accountToUpdate;
            }
            isExecuting = false;

        }                                
    }
    public static void handleAccountChange(Set<Id> affectedAccountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : affectedAccountIds) {
            Integer totalCount = [SELECT COUNT() FROM Contact 
                                  WHERE AccountId = :accountId 
                                  AND Is_Primary__c = true ];
                                  accountsToUpdate.add(new Account(
                    Id = accountId,
                    CountOfPrimaryContacts__c = totalCount
                ));
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    public static void cannotChangeAccountOwner(List<Contact> newContacts, Map<Id,Contact> oldContacts) {
        if (!isExecuting) {
            isExecuting = true;
            for (Contact con : newContacts) {
                Contact oldCon = oldContacts.get(con.Id);
                if(oldCon != null && con.AccountId != null && oldCon.AccountId != null) {
                    con.AccountId.addError('You cannot change Account owner, if contact have an account');
                }
            }
            isExecuting = false;
        }                
    } 
      
    public static void cantUpdatePhone(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        if (!isExecuting) {
            isExecuting = true;
            for(Contact c : newContacts) {
                Contact oldContact = oldContactsMap.get(c.Id);
                if(oldContact != null && (c.AccountId != null && c.Phone != oldContact.Phone)) {
                    c.Phone.addError('Cannot update phone field, if contact have an Account!!');
                }
            }
            isExecuting = false;
        }                
    } 
    
    public static void updatePhoneSecondVersion(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        if (!isExecuting) {
            isExecuting = true;
        Map<Id,Contact> conMap = new Map<Id,Contact>();
        for (Contact con : newContacts) {
            if(con.Is_Primary__c == true) {
                conMap.put(con.Id, con);
            }    
        }  
        for (Contact con : newContacts) {
            Contact oldContact = oldContactsMap.get(con.Id);
            if (conMap.containsKey(con.Id) && con.Phone != oldContact.Phone) {
                con.Phone.addError('You cannot update phone field, if contact have a Is_Primary__c = true');        
            }        
        } 
        isExecuting = false;
    }                
    }
}




/*
 public static void handleAccountChange(Set<Id> affectedAccountIds) {
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : affectedAccountIds) {
            Integer totalCount = [SELECT COUNT() FROM Contact 
                                  WHERE AccountId = :accountId 
                                  AND Is_Primary__c = true ];
                                  accountsToUpdate.add(new Account(
                    Id = accountId,
                    CountOfPrimaryContacts__c = totalCount
                ));
        }
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
*/