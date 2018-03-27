@isTest
public class AccountProcessorTest {
    public static testMethod void tesFutureMethod() {
        Account acc = new Account(Name = 'Test Acc');
        insert acc;
        Contact con = new Contact(AccountId = acc.Id, LastName = 'Test');
        insert con;
        List<Id> accountIdList = new List<Id>();
        accountIdList.add(acc.Id);
        Test.startTest();
        AccountProcessor.countContacts(accountIdList);
        Test.stopTest();
        acc = [SELECT Number_of_Contacts__c FROM Account LIMIT 1];
        System.assertNotEquals(0, acc.Number_of_Contacts__c);
    }
}