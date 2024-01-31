public with sharing class ListOfContactController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactList() {
      return [
        SELECT
          Id,
          Name,
          Title,
          Email,
          Phone
        FROM Contact
        LIMIT 10
      ];
    }
}


