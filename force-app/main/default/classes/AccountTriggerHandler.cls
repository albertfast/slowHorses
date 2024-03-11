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
 
 /* public with sharing class AccountTriggerHandler {
    public static void updateContactPhone(List<Account> newAcc, Map<Id, Account> oldMap) {
        Map<Id, Account> accMap = new Map<Id, Account>();
        for (Account acc : newAcc) {
            if (oldMap.get(acc.Id).Phone != acc.Phone) {
                accMap.put(acc.Id, acc);
            }
        }

        if (!accMap.isEmpty()) {
            // Custom Metadata Type'ı sorgula
            Allowed_App__mdt triggerSettings = Allowed_App__mdt.getInstance('Allowed_App__mdt');
            System.debug('triggerSettings: ' + triggerSettings);
            
            // Custom Metadata Type'da belirtilen uygulamalara izin veriyorsa devam et
            if (triggerSettings != null) {
                List<Contact> conList = [SELECT Id, AccountId, Phone FROM Contact WHERE AccountId IN :accMap.keySet()];
                List<Contact> listToUpdateContacts = new List<Contact>();
                System.debug('triggerSettings: ' + triggerSettings);
                
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
} */
