//
// (c) 2012 Appirio, Inc.
//
// EmailTemplatesControllerTest
// Show the email template list 
//
// 17 October 2016      Amit Sanwariya    			 	Original - For Send Email T-548021
//
@isTest
public class EmailTemplatesControllerTest {
    static testMethod void testClass(){
        EmailTemplateController emailController = new EmailTemplateController();
        
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHere';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        
        List<EmailTemplate> lstOfEmail = new List<EmailTemplate>();
        lstOfEmail.add(validEmailTemplate);
        insert lstOfEmail;
        emailController.lsEmail = lstOfEmail;
        
        
       
        emailController.getEmailTemplateList();
        
        
    }

}