/*
*Appirio Inc. 2016
*Name  : TestUtility
*Author: Amit SanWariya (Appirio)
*Date  : 12 Oct, 2016
*Description: For test data creation
*/
@isTest
public class TestUtility {
    //Method to create Opportunity
    public static Opportunity createOpportunity(Integer i, Id accountId, Boolean isInsert){
        Opportunity opp = new Opportunity(Name = 'Opportunity'+i,
                                          AccountId = accountId,
                                          StageName = 'C - Customer Identification',
                                          CloseDate = System.Today()+45);
        if(isInsert){
            insert opp;
        }
        return opp;
    }
    
    //Method to create Account
    public static Account createAccount(Integer i, Boolean isInsert ){
        Account acc = new Account(Name='Account'+i);
        if(isInsert){
            insert acc;
        }
        return acc;
    }
    
    /*Method to create Purchase
    public static Purchase__c createPurchase( Integer i, Id accountId,  Boolean isInsert){
      Purchase__c Pur=new Purchase__c(Name= 'Purcahse'+i,
                                ATC_Seller__c=AccountId,
                                Segment_Name__c='ADESA INLANE',
                               	Source_Id__c='Id'+i);
        
        if(isInsert){
           insert pur; 
        }  
        return Pur;
          
    }
    
    
    //Method to create Territory
    public static Territory__c createTerritory(String zipCode, String territory, Boolean isInsert) {
        Territory__c tert = new Territory__c(Name = zipCode,
                                             Zipcode__c = zipCode,
                                             ADESA_Territory_Name__c = territory);
        if(isInsert){
            insert tert;
        }
        return tert;
    }
    

    //Method to create Auction Detail
    public static Auction_Detail__c createAuctionDetail(Integer i, Id accountId, Boolean isInsert){
        Auction_Detail__c aucDetail = new Auction_Detail__c(Name = 'AuctionDetail'+i,
                                                      		Account__c = accountId,
                                                            Source_Id__c = 'Source'+i,
                                                            Buyer_Category__c='	Never Purchased',
                                                            Last_Sell_Date__c=system.today()-30);
        if(isInsert){
            insert aucDetail;
        }
        return aucDetail;
    }    */
    
    //Method to create a user to run test as
    public static User createTestUser(Boolean isInsert){
        User usr = new User(ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                            LastName = 'last',
                            Email = 'testuser@mail.com',
                            Username = 'testuseradesa@adesa.com',
                            Alias = 'alias',
                            Title = 'title',
                            TimeZoneSidKey = 'America/Los_Angeles',
                            EmailEncodingKey = 'UTF-8',
                            LanguageLocaleKey = 'en_US',
                            LocaleSidKey = 'en_US',
                            CompanyName = 'TEST');
        if(isInsert){
            insert usr;
        }
        return usr;
    }

    /*creating test data account for AccountTriggerHandler_Test.cls
    public static List<Account> createAccountRecords(String name, Integer count, Boolean isInsert){
        List<Account> AccountList = new List<Account>();
        for(integer i=0; i<count; i++){
            Account acc = new Account();
            acc.name = name + String.valueOf(i);
            AccountList.add(acc);
        }
        if(isInsert){
            insert AccountList;
        }
        return AccountList;
    }
    //creating test data purchases for AccountTriggerHandler_Test.cls
    public static List<Purchase__c> createPurchaseRecords(String name, String sourceId, Id SellerId, Id BuyerId, Integer count, Boolean isInsert){
        List<Purchase__c> PurchaseList = new List<Purchase__c>();
        for(integer i=0; i<count; i++){
            Purchase__c pur = new Purchase__c();
            pur.name = name + String.valueOf(i);
            pur.Source_Id__c = sourceId + String.valueOf(i);
            pur.ATC_Seller__c = SellerId;
            pur.ATC_Buyer__c = BuyerId;
            PurchaseList.add(pur);
        }
        if(isInsert){
            insert PurchaseList;
        }
    	return PurchaseList;
    }
    //creating test data Auction Details for AccountTriggerHandler_Test.cls
    public static List<Auction_Detail__c> createAuctionDetailRecords(String name, Id AccountId, String SourceId, Integer count, Boolean IsInsert){
        List<Auction_Detail__c> AuctionDetailList = new List<Auction_Detail__c>();
        for(integer i=0; i<count; i++){
            Auction_Detail__c aucD = new Auction_Detail__c();
            aucD.name = name + String.valueOf(i);
            aucD.Account__c = AccountId;
            aucD.Source_Id__c = SourceId + String.valueOf(i);
            AuctionDetailList.add(aucD);
        }
        if(isInsert){
            insert AuctionDetailList;
        }
        return AuctionDetailList;
    }*/
}