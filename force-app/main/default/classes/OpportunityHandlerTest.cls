@isTest
private class OpportunityHandlerTest {
  @isTest
  static void testOpportunityInsertUpdateDelete() {
    // Test Account oluştur
    Account testAccount = new Account(Name = 'Test Account');
    insert testAccount;

    // Test Opportunity oluştur
    Opportunity testOpportunity = new Opportunity(
      Name = 'Test Opportunity',
      StageName = 'Prospecting',
      CloseDate = System.today().addDays(30),
      Amount = 10000,
      AccountId = testAccount.Id
    );
    insert testOpportunity;

    // Opportunity'yi güncelle ve miktarı değiştir
    testOpportunity.Amount = 20000;
    update testOpportunity;

    // Opportunity'yi sil
    delete testOpportunity;

    // Account'ı doğrula
    Account updatedAccount = [
      SELECT Total_Opportunity_Amount__c, Total_Opportunity_Count__c
      FROM Account
      WHERE Id = :testAccount.Id
    ];
    System.assertEquals(
      0,
      updatedAccount.Total_Opportunity_Count__c,
      'Opportunity silindikten sonra toplam sayı 0 olmalıdır.'
    );
    System.assertEquals(
      0,
      updatedAccount.Total_Opportunity_Amount__c,
      'Opportunity silindikten sonra toplam miktar 0 olmalıdır.'
    );
  }
}
