// (c) 2012 Appirio, Inc.
//
// LookupAdditionContactsControllerTest
// Test Class for LookupAdditionContactsController
//
// 04 March 2013        Sudhir Kr. Jagetiya             Original Appirio Asset
// 07 December 2016     Amit Sanwariya    				Modified - For Send Email T-548021
//
@isTest
private class LookupAdditionContactsControllerTest {

    static testMethod void myUnitTest() {
    //inserting new Account 
    Account acc = new Account();
    acc.Name = 'Test Account' ;
    insert acc ;
    
    //inserting new contact
    Contact cntct = new Contact();
    cntct.LastName = 'Test Contact';
    cntct.Email = 'sudhir@metacube.com';
    cntct.AccountId = acc.id ;
    cntct.title = 'test tiltle' ;
    insert cntct ;
    
    
    // setting project Id in page.
    ApexPages.currentPage().getParameters().put('projId', acc.id); 
    
    // create object of class.
    LookupAdditionContactsController lookupController = new LookupAdditionContactsController() ;
    
    lookupController.selectedOptionValue = '-1' ;
    lookupController.getAdditionalContacts() ;
    system.assert(lookupController.contactsOption.size() == 1) ;
    
    // set selected Option value of picklist to 1.
    lookupController.selectedOptionValue = '1' ;
    lookupController.getAdditionalContacts() ;
    system.assert(lookupController.contactsOption.size() > 0) ;
    
    // set selected Option value of picklist to 2.
    lookupController.selectedOptionValue = '2' ;
    lookupController.getAdditionalContacts() ;
    system.assert(lookupController.contactsOption.size() == 1) ;
       
    }
}