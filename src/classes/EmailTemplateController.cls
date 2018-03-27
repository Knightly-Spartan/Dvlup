//
// (c) 2012 Appirio, Inc.
//
// EmailTemplateController
// Show the email template list 
//
// 01 March 2013        Sudhir kr. Jagetiya                Original - Asset
// 17 October 2016      Amit Sanwariya    			 	Modified - For Send Email T-548021
//
public without sharing class EmailTemplateController{
    public List<EmailTemplate> lsEmail{get;set;}
    public string templateFolderName {get;set;}
    public List<SelectOption> templateFolderOption {get; set;}

    public EmailTemplateController() {   
        templateFolderOption = new List<SelectOption>();

        for(Folder folder : [SELECT Type, Name,DeveloperName FROM Folder WHERE Type = 'Email'])
        templateFolderOption.add(new SelectOption(folder.DeveloperName,folder.Name));


        if(templateFolderOption.size() > 0) {
            templateFolderName = templateFolderOption.get(0).getValue();
            lsEmail = [SELECT e.TemplateType,e.Name, e.Description, e.Id FROM EmailTemplate e WHERE e.Folder.DeveloperName = : templateFolderName];
        }
    }

    public void getEmailTemplateList() {
        if(templateFolderName != null && templateFolderName != '')
        lsEmail = [SELECT e.TemplateType,e.Name, e.Description, e.Id FROM EmailTemplate e WHERE e.Folder.DeveloperName = : templateFolderName];
    }

    @IsTest 
    public static void testMethod1() {
        EmailTemplateController customCntrl = new EmailTemplateController();
        customCntrl.getEmailTemplateList();
    }
}