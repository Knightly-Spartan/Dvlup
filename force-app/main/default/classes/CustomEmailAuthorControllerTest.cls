//
// (c) 2012 Appirio, Inc.
//
// CustomEmailAuthorControllerTest
//
// 04 March 2013     	Sudhir Kr. Jagetiya         Original - Asset
// 07 December 2016     Amit Sanwariya	    		Modified - For Send Email T-548021
//
@isTest
private class CustomEmailAuthorControllerTest {
    static final String DEFAULT_DOCUMENT_FOLDER = 'SharedDocuments';
    static testMethod void testUnit(){
        Account acct = new Account();
        acct.name= 'Appirio';
        insert acct;

        
        ApexPages.currentPage().getParameters().put('Id', acct.id);
        
        CustomEmailAuthorController cusEmailContr = new CustomEmailAuthorController();
        PageReference pg = cusEmailContr.cancel();
        
        Id referalFolderId;
        for(Folder tempfolder : [SELECT Type, Name,DeveloperName FROM Folder WHERE Type = 'Document' AND DeveloperName = :DEFAULT_DOCUMENT_FOLDER]) {
            referalFolderId = tempfolder.Id;
        }

         List<Document> listDocuments = new List<Document>();

        //inserting new Attachment
        Document doc = new Document();
        doc.Name = 'sample_email.pdf';
        doc.body = Blob.valueOf('121121');
        doc.FolderId = referalFolderId;
        listDocuments.add(doc);

        doc = new Document();
        doc.Name = 'sample_email.pdf';
        doc.body = Blob.valueOf('121121');
        doc.FolderId = referalFolderId;
        listDocuments.add(doc);
        insert listDocuments;
        
		cusEmailContr.attachDoc=listDocuments; 
        cusEmailContr.selectedIndex= 1;
        cusEmailContr.deleteSelectedAttachment();
        
		string attachmentName = 'Attachment';
        
    
         //inserting new contact
        Contact cnt = new Contact();
        cnt.LastName = 'Sudhir';
        cnt.Email = 'sudhir@gmail.com';
        insert cnt ;
        cusEmailContr.contactId=cnt.id;
        cusEmailContr.ccEmails = 'cemail@gmail.com';
        cusEmailContr.bccEmails = 'cemail@gmail.com';
        cusEmailContr.addEmails= 'vemail@gmail.com';
        cusEmailContr.subject = 'Subject';
        cusEmailContr.emailSend();
 
    }
    
    static testMethod void testCustomSendEmail() {
        
        Account acct = new Account();
        acct.name= 'Appirio';
        insert acct;

        //inserting new contact
        Contact cnt = new Contact();
        cnt.LastName = 'Sudhir';
        cnt.Email = 'sudhir@gmail.com';
        insert cnt ;

        //inserting new account and using its id in page
        Account acc = TestUtility.createAccount(0, true);

        Id referalFolderId;
        for(Folder tempfolder : [SELECT Type, Name,DeveloperName FROM Folder WHERE Type = 'Document' AND DeveloperName = :DEFAULT_DOCUMENT_FOLDER]) {
            referalFolderId = tempfolder.Id;
        }

        List<Document> listDocuments = new List<Document>();

        //inserting new Attachment
        Document doc = new Document();
        doc.Name = 'sample_email.pdf';
        doc.body = Blob.valueOf('121121');
        doc.FolderId = referalFolderId;
        listDocuments.add(doc);

        doc = new Document();
        doc.Name = 'sample_email.pdf';
        doc.body = Blob.valueOf('121121');
        doc.FolderId = referalFolderId;
        listDocuments.add(doc);
        insert listDocuments;

        ApexPages.currentPage().getParameters().put('Id', acct.id);

        //invoking controller
        CustomEmailAuthorController cstmController = new CustomEmailAuthorController();
        cstmController.subject = 'testSubject';
        cstmController.mailBody = 'testBody';
        cstmController.sendTo = 'sudhir.jagetiya@test.com';
        cstmController.ccEmails = 'sudhir.jagetiya@test.com';
        cstmController.bccEmails = 'sudhir.jagetiya@test.com';
        cstmController.addEmails = 'sudhir.jagetiya@test.com';
        cstmController.templateType = 'text';
        //cstmController.pageMessage = 'testPageMessage';

        //invoking controller methods
        cstmController.attachIds = listDocuments.get(0).Id + ',' + listDocuments.get(1).Id;
        cstmController.showAttachmentList();

        //inserting new  EmailTemplate email
        List<EmailTemplate> emailTemplateList = [SELECT id FROM EmailTemplate LIMIT 1];
        system.assert(emailTemplateList.size() > 0);
        cstmController.templateId = emailTemplateList[0].id ;
        cstmController.mergeEmailTemplate();

        cstmController.selectedIndex = 0;
        cstmController.deleteSelectedAttachment();
        system.assertEquals(cstmController.attachDoc.size(), 1);
		
        cstmController.subject = 'TestSubject';
        cstmController.emailSend();

        cstmController.cancel();
        system.assertEquals(cstmController.attachDoc.size(), 0);
    }
}