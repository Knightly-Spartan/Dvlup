public class ContactTriggerHandler {
    
    public static void afterInsert(List<Contact> conNewList) {
        Set<Id> accIdSet = new Set<Id>();
        for (Contact con : conNewList) {
            accIdSet.add(con.AccountId);
        }
        reCalculateGrandTotal(accIdSet);
    }
    
    public static void afterDelete(List<Contact> conOldList) {
        Set<Id> accIdSet = new Set<Id>();
        for (Contact con : conOldList) {
            accIdSet.add(con.AccountId);
        }
        reCalculateGrandTotal(accIdSet);
    }

    public static void afterUpdate(List<Contact> conNewList, Map<Id, Contact> conOldMap) {
        Set<Id> accIdSet = new Set<Id>();
        
        for (Contact con : conNewList) {
            if (con.AccountId != conOldMap.get(con.Id).AccountId) {
                accIdSet.add(con.AccountId);
                accIdSet.add(conOldMap.get(con.Id).AccountId);
            }
            else if (con.Total__c != conOldMap.get(con.Id).Total__c) {
            	accIdSet.add(con.AccountId);
            }
        }
        
        reCalculateGrandTotal(accIdSet);
    }
    
    public static void beforeUpdate(List<Contact> conNewList, Map<Id, Contact> conOldMap) {
		DateTime customDateTime = DateTime.now();
		String TDate = customDateTime.formatGMT('MMM d yyyy');
        for(Contact con : conNewList){
            if(conOldMap.get(con.Id).FirstName != con.FirstName){
                con.Track_History__c = 'Name value changed from "' + conOldMap.get(con.Id).FirstName + '" to "' + con.FirstName+'" on ' + TDate + '\n' + con.Track_History__c;
            }
            if(conOldMap.get(con.Id).Email != con.Email){
                con.Track_History__c = 'Email value changed from "' + conOldMap.get(con.Id).Email + '" to "' + con.Email + '" on '+ TDate + '\n' + con.Track_History__c;   
            }
        }
    }
    
    public static void reCalculateGrandTotal(Set<Id> accIdSet) {
 		
        List<Account> accToUpdate = new List<Account>();
		
		for (Account acc : [SELECT Id, Grand_Total__c, (SELECT Id, Total__c 
                                                       	FROM Contacts) 
                            FROM Account 
                            WHERE Id in :accIdSet]) {
                                acc.Grand_Total__c = 0;
                                for (Contact con : acc.Contacts) {
                                    acc.Grand_Total__c += con.Total__c;
                                }
                                accToUpdate.add(acc);
                            }

		update accToUpdate;
		/*
		Account acc;
        List<Account> accToUpdate = new List<Account>();
        for (AggregateResult aggResult: [SELECT AccountId, sum(Total__c) GTotal
											FROM Contact
											WHERE AccountId In :accIdSet
											GROUP BY AccountId]) {
            string accId = (string) aggResult.get('AccountId');
            decimal gTotal = (decimal) aggResult.get('GTotal');
            acc = new Account(Id = accId , Grand_Total__c = gTotal);
			accToUpdate.add(acc);
        }
		update accToUpdate;
		*/
    }
}