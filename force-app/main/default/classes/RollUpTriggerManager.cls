public class RollUpTriggerManager {
    public static void rollUpValues(Set<Id> accIdSet) {
    	Set<String> fieldValueSet = new Set<String>();
        List<Account> parentsToUpdate = [SELECT Id, Name, (SELECT Id, Name, Type__c 
                                                           FROM Contacts) 
                                         FROM Account
                                         WHERE Id = :accIdSet];
        for (Account acc : parentsToUpdate) {
            fieldValueSet = new Set<String>();
            for (Contact con : acc.Contacts) {
                fieldValueSet.add(con.Type__c);
            }
            List<String> concatenateList = new List<String>(fieldValueSet);
            acc.Contact_Types__c = String.join(concatenateList, ',');
        }
        update parentsToUpdate;
    }
}