public class FirstVFPageController {
    public Class__c clas {get;set;}
    public Boolean showDetails {get;set;}
    public String accountId {get;set;}
    
    public FirstVFPageController(ApexPages.StandardController stdController) {
        clas = [SELECT Name From Class__c WHERE Account__c = :stdController.getId()];
        showDetails = true;
    }
    
    public void toggleDetails() {
    	showDetails = !showDetails;
    }
}