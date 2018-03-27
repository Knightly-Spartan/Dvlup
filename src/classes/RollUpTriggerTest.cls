@isTest
public class RollUpTriggerTest {
    private static testmethod void testRollUp() {
        Contact con = [SELECT Id, AccountId, Type__c FROM Contact LIMIT 1];
        Account acc = new Account(Name = 'TestAccount2');
        Test.startTest();
        con.Type__c = 'Personal';
        con.AccountId = acc.Id;
        update con;
        delete con;
        undelete con;
        Test.stopTest();
    }
    @testSetup
    private static void setupTestData() {
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
        Contact con = new Contact(LastName = 'Lastname', AccountId = acc.Id, Type__c = 'Business');
        insert con;
    }
}