@isTest
public class ContactTriggerHandlerTest {
    private static testMethod void testContactUpdate() {
        UtilityTest util = new UtilityTest();
        List<Contact> conList = new List<Contact>();
        
        for(Integer i = 0; i < 10; i++) {
            conList.add(util.createContact(i));
        }
        
        insert conList;
        
        conList[0].FirstName = 'Amit';
        conList[2].Email = 'amit@test.com';
        
        try{
        	update conList;    
        }
        
        catch(Exception e) {
            if (conList[0].Track_History__c.contains('Amit')) {
            System.assert(true);
        }
        else {
            System.assert(false);
        }
        
        if (conList[2].Track_History__c.contains('amit@test.com')) {
            System.assert(true);
        }
        else {
            System.assert(false);
        }
        }
    }
}