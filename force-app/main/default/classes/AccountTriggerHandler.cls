public with sharing class AccountTriggerHandler {
    public static void updateContactPhone(List<Account> newAcc, Map<Id,Account> oldMap) {
        Map<Id,Account> accMap = new Map<Id,Account>();
        for (Account acc : newAcc) {
            if (oldMap.get(acc.Id).Phone != acc.Phone) {
                accMap.put(acc.Id, acc);
            }
        }

        if (!accMap.isEmpty()) {
            List<Contact> conList = [SELECT Id,AccountId, Phone FROM Contact WHERE AccountId IN :accMap.keySet()];
            List<Contact> listToUpdateContacts = new List<Contact>(); 
            for (Contact con : conList) {
                con.Phone = accMap.get(con.AccountId).Phone;
                listToUpdateContacts.add(con);
            }
            if (!listToUpdateContacts.isEmpty()) {
                update listToUpdateContacts;
            }
        }
    }
}