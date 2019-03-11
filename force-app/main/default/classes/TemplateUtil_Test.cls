//
// (c) 2012 Appirio, Inc.
//
// Utility class to process EmailTemplate and merge record field values
//
// 7 December 2016		  Amit Sanwariya (Appirio)		Test Class for TemplateUtil
//
@isTest
public class TemplateUtil_Test {
    private static testMethod void testTemplateUtilController() {
		EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate LIMIT 1];
        Account acc = TestUtility.createAccount(0, true);
        
        Test.startTest();
        TemplateUtil controller= new TemplateUtil();
        TemplateUtil.GetMail(emailTemplate.Id, acc.Id);
        Test.stopTest();
    }
    
    @testSetup
    private static void testSetup() {
        EmailTemplate emailTemplate = new EmailTemplate (developerName = 'test', Subject='{!Account.Name}', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test'); // plus any other fields that you want to set
		insert emailTemplate;
    }
}