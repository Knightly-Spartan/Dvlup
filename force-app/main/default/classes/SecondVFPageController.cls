public class SecondVFPageController {
    public Account acc {get;set;}
    
    public SecondVFPageController(ApexPages.StandardController stdController) {
        acc = (Account)stdController.getRecord();
    }    
    
    public void save() {
       if (acc.Industry == null) {
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.IndustryRequired));
       } else {
           update acc;
       }
    }
}