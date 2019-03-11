public with sharing class VFAccountController {
  public String message{get;set;}
  public Id accountId{get;set;}
  public Id contactId{get;set;}
  public boolean showDetails{get;set;}
  public boolean childDetails{get;set;}
  public User user{get;set;}
  public Id userId{get;set;}
  public Account accountObject{get;set;}
  public Contact conObject{get;set;}
  public List<selectOption> accountList{get;set;}
  public List<selectOption> contactList{get;set;}
  public Map<String, Account> acctIdToObjMap = new Map<String, Account>();
  public Map<String, Contact> contactMap = new Map<String, Contact>();
  
  public VFAccountController(){
    showDetails = false;
    childDetails = false;
    accountList = new List<selectOption>();
    userId = userInfo.getUserId();
    Account accountObject = new Account();
    Contact conObject = new Contact();
    
      if(ApexPages.currentPage().getParameters().get('Id') != NULL ){
        userId = ApexPages.currentPage().getParameters().get('Id');
      } else {
        userId = UserInfo.getUserId();
      }
      List<Account> acctList = [SELECT Id, Name, Phone 
                                FROM Account
                                WHERE OwnerId =: userId];
      for(Account acct: acctList){
        accountList.add(new selectOption(acct.Id, acct.Name));
        acctIdToObjMap.put(acct.Id,acct);
      }   
  }
      public void changeDetails(){
      showDetails = true;
      childDetails = false;
      }
      
      public void changeChild(){                  
      childDetails = false;
      
      }  
   
  
  public void submit(){
    if(validate()){
      showDetails = true;
      childDetails = true;
      List<Contact> conList = [SELECT Id, FirstName, Email, AccountId 
                               FROM Contact
                               WHERE Id =: accountId];
      for(Contact con: conList){
        contactList.add(new selectOption(con.Id, con.Name));
        contactMap.put(con.Id, con);
      } 
    } else {
      showDetails = false;
      childDetails = false;
    }
  }
  
  public PageReference cancel(){
    PageReference landingPage = new PageReference('/apex/VFAccount');
    return landingPage;
  }
  
  public boolean validate(){
    String errorMessage='';
    Boolean isValid;
    if(userId == ''){
      errorMessage = 'Please select a value.';
      isValid = false;
      ApexPages.Message errMessage = new ApexPages.Message(ApexPages.Severity.Error, errorMessage);
      ApexPages.addMessage(errMessage);
    }
    else {
      isValid = true;
    }
    return isValid;
  }
}