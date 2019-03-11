public class EditAccountController {
    public Account acc{get;set;}
    public EditAccountController(){
        String AccountId=ApexPages.currentPage().getParameters().get('aId');
        if(AccountId!=null){
        List<Account> accList= [SELECT Name, Phone FROM Account WHERE Id = :AccountId];
        if(accList.size() > 0) {
            acc= accList[0];
        }
        }
        else{
            acc = new Account();
        }
    }
    public PageReference save(){
        if(acc!=null){
            if (validateData()) {                     
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Error: Baka Phone Number To Daalo.');
            ApexPages.addMessage(errMsg);
            return null;
            }
            else {
            update acc;
            }
        }
        else {
            if (validateData()) {                     
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Error: Baka Phone Number To Daalo.');
            ApexPages.addMessage(errMsg);
            return null;
            }
            else {
            insert acc;
            }
        }
        PageReference homePage = new PageReference('/' + acc.Id);  
        return homePage;
    }

    public PageReference cancel(){
        PageReference homePage = new PageReference('/' + acc.Id);  
        return homePage;
    }

    public boolean validateData() {
        if (acc.Phone == null) {
            return true;
        } else {
            return false;
        }
    }
}