public class DTAuraController {
     
    //Get Contact List
    @AuraEnabled
    public static List<Account> getContactList(String recordId){
    
       system.debug('recordId..'+recordId);
        List<Account> conList = new List<Account>();
        conList = [SELECT Id, Name, Industry FROM Account];
        return conList;
    }
    
    
     @AuraEnabled
    public static Account getColumnData(String recId){
       
       system.debug('recId.'+recId);
        List<Account> conList = new List<Account>();
        Account con = [SELECT Id, Name, Industry FROM Account where Id = :recId];
        system.debug('recId.'+con);
        return con;
    }
     
     
     @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOpts.add(a.getValue());
        }
        system.debug('allOpts.'+allOpts);
        return allOpts;
    }
    
      @AuraEnabled
    public static void updateContact(Map<String, String> m1, String recId)
    {
        String objName = 'contact' ;
        sobject sObj = Schema.getGlobalDescribe().get(objName).newSObject(recId) ;
        for(String m : m1.keyset())
        {
        sObj.put(m,m1.get(m)) ;
        }
        try
        {
        update sObj ;
        }
        catch(Exception ex){ 
        system.debug(ex);   
        }
    }
     
}