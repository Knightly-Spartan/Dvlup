// (c) 2012 Appirio, Inc.
//
// LookupAdditionContactsController
// Lookup for additional email,cc and bcc. 
//
// 01 March 2013        Sudhir Kr. Jagetiya             Original Appirio Asset
// 17 October 2016      Amit Sanwariya    			 	Modified - For Send Email T-548021
//
public without sharing class LookupAdditionContactsController {
    
    public String accContact {get;set;} 
    public String selectedOptionValue {get;set;}
    public String fieldPopulatingId1 {get;set;}
    public String fieldPopulatingId2 {get;set;}
    public String fieldPopulatingId3 {get;set;}
    public List<SelectOption> contactsOption {get;set;} 
    public List<SelectOption> selectListOptions {get;set;}
    
   
    public String projectId {get;set;}
    public String accountName {get;set;}
    private List<user> listUser; 
          
    public LookupAdditionContactsController() {
        contactsOption=new List<SelectOption>();
        contactsOption.add(new SelectOption('--None--','--None--'));
        selectListOptions = new List<SelectOption>();
        selectListOptions.add(new SelectOption('1','All Co-workers In Company'));
        if(projectId != null && projectId != '') {
            selectListOptions.add(new SelectOption('2','Contacts: Account '+accountName));
        }
        selectedOptionValue = '1';
        getAdditionalContacts();
    }

    // method to get additional contact list for Additional To,BCC and CC email addresses.
    public pagereference getAdditionalContacts(){ 
        contactsOption=new List<SelectOption>();
        if (selectedOptionValue=='1') {
            getUsers() ;    
        }
        else if (selectedOptionValue == '2') {
            getContacts() ;
        }
        if(contactsOption.size() == 0 ) {
            contactsOption.add(new SelectOption('--None--','--None--'));
        }
        return null;
    }
    
    
    // get users
    private void getUsers() {
        List<User> lstAddUsers = new List<User>() ;
        lstAddUsers = [SELECT Name, Title, Email FROM User WHERE Email != null AND IsActive = true ORDER BY Name LIMIT 500] ;
        for(user u : lstAddUsers) {
            contactsOption.add(new SelectOption(u.email ,u.Name));
        }
    }
    
    // get contacts
    private void getContacts() {
        List<Contact> lstAddContacts = new List<Contact>() ;
        lstAddContacts = [SELECT Name, Account.Name, Title, Email FROM Contact WHERE AccountId = :projectId AND Email != null ORDER BY Name]; 
        for(contact c : lstAddContacts) {
            contactsOption.add(new SelectOption(c.Email ,c.Name));
        }
    }  
}