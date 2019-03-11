public class AccountOwnerDetailsController {
    public Account acc{get;set;}
    public AccountOwnerDetailsController(){
        String accountId=ApexPages.currentPage().getParameters().get('Id');
        acc = [SELECT Id, Name, Active__c, Active_Depend__c FROM Account WHERE Id = :accountId LIMIT 1];
    }
}