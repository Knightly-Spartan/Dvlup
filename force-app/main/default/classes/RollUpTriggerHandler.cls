public class RollUpTriggerHandler {
    public static void AfterInsert(List<Contact> newRecordsList) {
        Set<Id> accIdSet = new Set<Id>();
        for (Contact con : newRecordsList){
            accIdSet.add(con.AccountId);
        }
        if (accIdSet.size() > 0) {
            RollUpTriggerManager.rollUpValues(accIdSet);
        }
    }
    public static void AfterUpdate(List<Contact> newRecordsList, Map<Id, Contact> oldRecordsMap) {
        Set<Id> accIdSet = new Set<Id>();
        for (Contact con : newRecordsList){
            if (con.AccountId != oldRecordsMap.get(con.Id).AccountId) {
            	accIdSet.add(con.AccountId);
                accIdSet.add(oldRecordsMap.get(con.Id).AccountId);
            } else if (con.Type__c != oldRecordsMap.get(con.Id).Type__c) {
                accIdSet.add(con.AccountId);
            }
        }
        if (accIdSet.size() > 0) {
            RollUpTriggerManager.rollUpValues(accIdSet);
        }
    }
    public static void AfterDelete(List<Contact> oldRecordsList) {
        Set<Id> accIdSet = new Set<Id>();
        for (Contact con : oldRecordsList){
            accIdSet.add(con.AccountId);
        }
        if (accIdSet.size() > 0) {
            RollUpTriggerManager.rollUpValues(accIdSet);
        }
    }
    public static void AfterUnDelete(List<Contact> newRecordsList) {
        Set<Id> accIdSet = new Set<Id>();
        for (Contact con : newRecordsList){
            accIdSet.add(con.AccountId);
        }
        if (accIdSet.size() > 0) {
            RollUpTriggerManager.rollUpValues(accIdSet);
        }
    }    
}