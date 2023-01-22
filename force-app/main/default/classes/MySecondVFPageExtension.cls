public class MySecondVFPageExtension {
    public Boolean switchRelatedList {get;set;}
    
    public MySecondVFPageExtension(ApexPages.StandardController stdController) {
        switchRelatedList=false;
    }
    
    public List<Contact> getContacts() {
        return [Select FirstName, LastName, Email FROM Contact LIMIT 5];
    }
    
    public void toggleRelatedList() {
        switchRelatedList=!switchRelatedList;
    } 
}