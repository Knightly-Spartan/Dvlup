public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accountIdList) {
        List<Account> accountsToUpdate = [SELECT Number_of_Contacts__c, 
                                          		 (SELECT Id FROM Contacts) 
                                          FROM Account 
                                          WHERE Id IN :accountIdList];
        if (accountsToUpdate.size() > 0) {
            for (Account acc : accountsToUpdate) {
                acc.Number_of_Contacts__c = 0;
                for (Contact con : acc.Contacts) {
                    acc.Number_of_Contacts__c += 1;
                }                      
            }
            update accountsToUpdate;
        }
    }
}