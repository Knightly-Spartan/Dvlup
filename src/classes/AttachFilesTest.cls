//
// (c) 2012 Appirio, Inc.
//
// AttachFilesTest
//
// 04 March 2013        Sudhir Kr. Jagetiya          Original - Asset
// 07 December 2016     Amit Sanwariya    			 Modified - For Send Email T-548021
// 
//
@isTest
private class AttachFilesTest {
	static final String DEFAULT_DOCUMENT_FOLDER = 'SharedDocuments';
	static testMethod void testAttachFiles() {

	//insert new account
	Account acc = TestUtility.createAccount(0, true);

	ApexPages.currentPage().getParameters().put('projId',acc.id);
	Id referalFolderId;
	for(Folder tempfolder : [SELECT Type, Name,DeveloperName FROM Folder
								WHERE Type = 'Document'
								AND DeveloperName = :DEFAULT_DOCUMENT_FOLDER]) {
		referalFolderId = tempfolder.Id;
	}

	//inserting new Attachment
	Document doc = new Document();
	doc.Name = 'sample_email.pdf';
	doc.body = Blob.valueOf('121121');
	doc.FolderId = referalFolderId;
	insert doc;

	//invoking class and its methods
	AttachFiles AttachFilescontroller = new AttachFiles();
	AttachFilescontroller.fileName = 'testfilename';
	AttachFilescontroller.done();
	}
}