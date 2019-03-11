//
// (c) 2012 Appirio, Inc.
//
// AttachFiles
//
// 01 Feb 2013            Sudhir Kr. Jagetiya           Original - Asset
// 17 October 2016     	  Amit Sanwariya    			Modified - For Send Email T-548021
//
public without sharing class AttachFiles {
    static final String DEFAULT_DOCUMENT_FOLDER = 'SharedDocuments';

    public List<string> attachDocId {get;set;}
    public String fileName {get;set;}
    public string attachIds {get;set;}
    public boolean closeWindow{get;set;}
    public string projectId {get;set;}
    public Document attach{get; set;}
    private Id referalFolderId;

    public AttachFiles() {
        closeWindow = false;
        attachDocId = new List<string>();
        attach = new Document();
        projectId = ApexPages.currentPage().getParameters().get('projId');
        for(Folder folder : [SELECT Type, Name,DeveloperName FROM Folder WHERE Type = 'Document']) {
            if(folder.DeveloperName.equalsIgnoreCase(DEFAULT_DOCUMENT_FOLDER)) {
                referalFolderId = folder.Id;
            }
        }
    }

    public void done() {
        if(fileName != null && fileName != '') {
            if(referalFolderId != null){
                attach.FolderId = referalFolderId;
            }
            attach.Name = fileName;
            insert attach;
            attachDocId.add(attach.Id);
        }
        getAttachedIds();
        closeWindow= true;
        attach.Body = null;
    }

    private void getAttachedIds() {
        attachIds = '';
        for(string str : attachDocId) {
            if(attachIds == '') {
                attachIds = str;
            } else {
                attachIds += ','+str;
            }
        }
    }
}