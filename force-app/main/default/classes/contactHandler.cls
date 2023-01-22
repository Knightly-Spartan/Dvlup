public class contactHandler {
    
    public static void calculateNumberOfContacts(list<Contact>contactList){
      set<Id>AccountIdSet = new Set<Id>();
      Map<Id,Account> accountMap = new Map<Id,Account>();
        for(Contact conObj :contactList){
            if(conObj.AccountID!=null){
                AccountIdSet.add(conObj.AccountID);
            }
        }
        if(AccountIdSet!=null && AccountIdSet.size()>0){
            for(AggregateResult agrResultObj : [select count(id) contCount,AccountId from Contact where AccountId in:AccountIdSet Group by AccountId]){
                
             Account actObj = new Account();
             actObj.Id = (Id)agrResultObj.get('AccountId');
             actObj.No_Of_Contacts__c = (Integer)agrResultObj.get('contCount');
             accountMap.put(actObj.id,actObj);
            }
            if(accountMap!=null && accountMap.size()>0){
                update accountMap.values();
            }
        }
    }

}