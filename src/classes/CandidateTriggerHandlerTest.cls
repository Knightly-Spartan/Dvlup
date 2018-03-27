@isTest
public class CandidateTriggerHandlerTest {
    private static testMethod void testCandidateInsert() {
        UtilityTest util = new UtilityTest();
        List<Candidate__c> canList = new List<Candidate__c>();
                
        for(Integer i = 0; i < 10; i++) {
            canList.add(util.createCandidate(i, false));
        }
        
        insert canList;
        canList[0].Date_Of_Birth__c = System.today().addDays(-900);
        
        try {
            update canList;
        }
        catch (Exception e ) {
            if (e.getMessage().contains('Duplicate Record')) {
                System.assert(true);
            }
            else {
                System.assert(false);
            }
        }
    }
    
	public static testMethod void checkCandidateDOB(){
		UtilityTest util = new UtilityTest();
        List<Candidate__c> canList = new List<Candidate__c>();
        
        for(Integer i = 0; i < 10 ;i++){
            
            canList.add(util.createCandidate(i, false));
        }
        
        insert canList;
        canList[1].Date_of_Birth__c = null;
        canList[0].Date_of_Birth__c = System.today().addDays(-8000);
        
        try{
            update canList;
        }
        catch(Exception e ){
            if(e.getMessage().contains(Label.DOB_Can_t_Be_Null)){
                System.assert(true);
            }
            else{
                System.assert(false);
            }
        }
    }
}