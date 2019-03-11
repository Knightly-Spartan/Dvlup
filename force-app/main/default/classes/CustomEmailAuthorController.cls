//
// (c) 2012 Appirio, Inc.
//
// CustomEmailAuthorController
//
// 01 March 2013        Sudhir Kr. Jagetiya              Original - Asset
// 17 October 2016      Amit Sanwariya    			 	 Modified - For Send Email T-548021
//
public without sharing class CustomEmailAuthorController {

    static final String EMAIL_SERVICE_CLASS = 'Case Activity Track';

    public String subject {get;set;}
    public String sendTo {get;set;}
    public String mailBody {get;set;}
    public String fromContact {get;set;}
    public String ccEmails {get;set;}
    public String bccEmails {get;set;}
    public String addEmails {get;set;}
    public String textBody {get;set;}
    public String pageMessage {get;set;}
    public String templateType {get;set;}
	
    public String contactId {get;set;}
    public Account existingProject {get;set;}
    public List<Document> attachDoc {get;set;}
    public List<SelectOption> ProjectContacts {get; set;}

    public Integer selectedIndex {get;set;}
    public string attachIds {get;set;}
    public string templateId {get;set;}

    public Set<string> attachedItems{
        get{
            if(attachedItems == Null)
            attachedItems = new Set<string>();
            if(attachIds != Null && attachIds != '') {
                for(string str :attachIds.split(',')) {
                    attachedItems.add(str);
                }
            }
            return attachedItems;
        }
        set;
    }

    private string existingProjectId;
    private string allAttachIds;

    private List<string> lsToMail;
    private List<string> lsCcMail;
    private List<string> lsBccMail;

    private String replyToEmailId;

    public CustomEmailAuthorController() {
        attachDoc = new List<Document>();
        allAttachIds = '';
        replyToEmailId = '';
        templateType = '';
        existingProjectId = ApexPages.currentPage().getParameters().get('Id');

        if(existingProjectId != null && existingProjectId != '') {
            existingProject = [SELECT id, Name
                               FROM Account
                               WHERE Id = :existingProjectId LIMIT 1];
        }

        getProjectContacts();

        List<EmailServicesAddress> emailServiceAddresses = [SELECT LocalPart, Function.FunctionName,
                                                                    Function.IsActive, FunctionId,
                                                                    EmailDomainName
                                                            FROM EmailServicesAddress
                                                            WHERE Function.IsActive = true
                                                            AND Function.FunctionName = :EMAIL_SERVICE_CLASS];

        if(emailServiceAddresses.size() > 0) {
            replyToEmailId = emailServiceAddresses.get(0).LocalPart +'@'+emailServiceAddresses.get(0).EmailDomainName;
        }

        for(EmailTemplate defaultEmailTemplate : [SELECT id FROM EmailTemplate WHERE DeveloperName = 'TEMPLATE_External_Emails']){
            templateId = defaultEmailTemplate.Id;
        }
        mergeEmailTemplate();

    }

    private void getProjectContacts() {
        ProjectContacts = new List<SelectOption>();

        for(User user : [SELECT Email, Id, Name FROM User WHERE Id = :Userinfo.getUserId()]) {
            ProjectContacts.add(new SelectOption('',user.Name+' "<'+user.Email+'>"'));
        }

        for(OrgWideEmailAddress owa : [Select id, Address, DisplayName From OrgWideEmailAddress ]) {
            ProjectContacts.add(new SelectOption(owa.Id,owa.DisplayName+' "<'+owa.Address+'>"'));
        }
    }

    public PageReference emailSend(){
        if(!valiadatePage()) {
            return null;
        }

        // Send Message
        List<Messaging.Sendemailresult> lsResult = sendMessage();

        if(existingProjectId == null || existingProjectId == '') {
            return new PageReference('/home/home.jsp');
        }

        for(Messaging.Sendemailresult result : lsResult) {
            if(result.isSuccess()) {
                // Create Activity History
                createActivityHistory();
                return new ApexPages.StandardController(existingProject).view();
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,result.getErrors().get(0).getMessage()));
                return Null;
            }
        }
        return null;
    }

    public PageReference cancel() {
        deleteAttachedDoc();
        if(existingProjectId == null || existingProjectId == '') {
            return new PageReference('/home/home.jsp');
        }
        PageReference page = new ApexPages.StandardController(existingProject).view();
        return page;
    }

    public void showAttachmentList() {
        getAttachedList();
    }

    public void mergeEmailTemplate() {
        if(templateId != Null && templateId != '') {
            try {
                getTemplateFormat();
            } catch(System.Exception ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error while parsing email template.'));
            }
        }
    }

    public void deleteSelectedAttachment() {
        delete attachDoc.get(selectedIndex);
        attachDoc.remove(selectedIndex);
    }

    private List<Messaging.Sendemailresult> sendMessage() {
        String threadId, updatedText;
        threadId = '<br/><br/>Account thread ID : [' + existingProject.Id+']';
        Messaging.SingleEmailMessage newEmail;
        newEmail = new Messaging.SingleEmailMessage();

        newEmail.setToAddresses(lsToMail);
        newEmail.setCcAddresses(lsCcMail);
        newEmail.setBccAddresses(lsBccMail);

        newEmail.setSubject(subject);

        if(templateType.equalsIgnoreCase('text')) {
            updatedText = mailBody.replace('\n', '<br/>');
        } else {
            updatedText = mailBody;
        }

        /*//Logic for masking
        if(!String.isBlank(updatedText)){
            //Mask any SSNs
            updatedText = updatedText.replaceAll('\\d{3}-\\d{2}-\\d{4}', 'XXX-XX-XXXX');
            textBody = textBody.replaceAll('\\d{3}-\\d{2}-\\d{4}', 'XXX-XX-XXXX');
            // Mask CC
            updatedText = updatedText.replaceAll('\\d{9}', 'XXXXXXXXX');
            textBody = textBody.replaceAll('\\d{9}', 'XXXXXXXXX');
        }*/

        newEmail.setHtmlBody(updatedText + threadId);

        newEmail.setSaveAsActivity(false);
        newEmail.setWhatId(existingProject.Id);
        newEmail.setTargetObjectId(contactId);

        if(replyToEmailId != null && replyToEmailId != '')
            newEmail.setReplyTo(replyToEmailId);

        if(fromContact != Null && fromContact != '')
            newEmail.setOrgWideEmailAddressId(fromContact);

        List<Messaging.Emailfileattachment> attachedFiles = new List<Messaging.Emailfileattachment>();

        if(attachDoc != null) {
            for(Document a : attachDoc) {
                Messaging.Emailfileattachment emailAttach = new Messaging.Emailfileattachment();
                emailAttach.setFileName(a.Name);
                emailAttach.setBody(a.body);
                attachedFiles.add(emailAttach);
            }
            if(attachedFiles.size()>0)
                newEmail.setFileAttachments(attachedFiles);
        }
        return Messaging.sendEmail(new List<Messaging.Email> {newEmail});
    }

    private void createActivityHistory() {
        String attachmentName = '';
        for(Document a : attachDoc) {
            if(attachmentName == '')
                attachmentName += a.Name;
            else
                attachmentName += '; '+ a.Name;
        }
        // Creating Task for showing in Activity History Section
        Task objTask = new Task();
        objTask.Subject = 'Email: '+subject;
        objTask.ActivityDate = Date.today();
        objTask.Status = 'Completed';
        objTask.Type = 'Email';
        objTask.Priority = 'Normal';
        objTask.Description = 'Additional To: ' + addEmails + '\nCC: ' + ccEmails + '\nBCC: ' + bccEmails + '\nAttachment: '+attachmentName+'\n\nSubject: '+ subject + '\nBody: \n';
        objTask.Description += textBody;
        objTask.WhatId = existingProjectId;
        insert objTask;

        /*EmailMessage email = new EmailMessage();
        email.BccAddress = bccEmails;
        email.CcAddress = ccEmails;
        email.Incoming=false;
        email.ParentId = existingProjectId;
        email.Subject = subject;
        email.ToAddress = sendTo != null ? sendTo : '';
        email.ToAddress += sendTo != null ? ';' : '';
        email.ToAddress += addEmails != null && addEmails != '' ? addEmails : '';
        email.FromAddress = existingProject.owner.Email;
        email.FromName = existingProject.Owner.Name;
        email.TextBody = textBody;
        email.activityId = objTask.Id;
        insert email;

        List<Attachment> emailAttchments = new  List<Attachment>();
        for(Document a : attachDoc){
            Attachment attchment = new Attachment();
            attchment.Name = a.Name;
            attchment.Body = a.body;
            attchment.ParentId = email.Id;
            emailAttchments.add(attchment);
        }
        if(emailAttchments.size() > 0){
            insert emailAttchments;
        }*/
        deleteAttachedDoc();
    }

    private void deleteAttachedDoc() {
    // Delete Documents used for Attachment
    if(attachDoc != Null && attachDoc.size() > 0) {
        delete attachDoc;
        attachDoc.clear();
    }
    }

    private Boolean valiadatePage() {
        // Validate Additional To Emails
        lsToMail = new List<string>();
        if(existingProject != null &&  contactId != Null) {
            List<Contact> selectedContacts = [SELECT Name, Id, Email FROM Contact WHERE Id = :contactId AND Email != null];
            if(selectedContacts != null && !selectedContacts.isEmpty()) {
                sendTo = selectedContacts[0].Email;
                if(validateEmailAddress(sendTo) == Null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid "To" email id.'));
                    return false;
                }
                else    {
                    lsToMail.Add(sendTo);
                }
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Contact must have valid Email Address.'));
                    return false;
                }
                } else if(addEmails == null || addEmails == '') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter either "To" or "Additional To" email ids.'));
                    return false;
                }

        // Validate Additional To Emails
        if(addEmails != Null && addEmails.length() > 0) {
            lsToMail.addAll(validateEmailAddress(addEmails));
            if(lsToMail == Null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid "Additional To" email ids.'));
                return false;
            }
        }

        // Validate CC Emails
        lsCcMail = new List<string>();
        if(ccEmails != Null && ccEmails.length() > 0) {
            lsCcMail = validateEmailAddress(ccEmails);
            if(lsCcMail == Null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid "Cc" email ids.'));
                return false;
            }
        }
        // Validate BCC Emails
        lsBccMail = new List<string>();
        if(bccEmails != Null && bccEmails.length()>0)   {
            lsBccMail = validateEmailAddress(bccEmails);
            if(lsBccMail == Null)   {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter valid "Bcc" email ids.'));
                return false;
            }
        }
        // Validate Subject
        if(subject == Null || subject == '')    {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter subject.'));
            return false;
        }
        return true;
    }

    private void getTemplateFormat()    {
        EmailTemplate email = TemplateUtil.GetMail(templateId,existingProjectId);
        subject = email.subject;
        mailBody = email.htmlValue;
        //textBody = email.Body;
        templateType = email.TemplateType.toLowerCase();
        //if(templateType.equalsIgnoreCase('text'))
        //mailBody = mailBody.replace('\n', '<br/>');

    }

    private List<string> validateEmailAddress(string addressString) {
        String regex='(\\w+)([\\.-]?\\w+)*@(\\w+)([\\.-]?\\w+)*\\.(\\w+)';
        //user can use both comma or semicolon
        //splits into comma seperated email ids
        if(addressString != Null)   {
            String[] csEmails = addressString.split(';');
            List<string> emailAddresses = new List<string>();
            for(String csEmail: csEmails)   {
                String[] emails = csEmail.split(',');
                for(String email: emails)   {
                    email = email.trim();
                    Pattern p = Pattern.compile(regex);
                    Matcher m = p.matcher(email);
                    if(m.matches()) {
                        emailAddresses.add(email);
                    }
                    else {
                        emailAddresses.clear();
                        return null;
                    }
                }
            }
            return emailAddresses ;
        }
        return Null;
    }

    private void getAttachedList() {
        attachDoc.clear();
        Set<string> strAttachmentIds = attachedItems;
        if(strAttachmentIds.size() > 0) {
            attachDoc = [Select id, Name, body, bodylength from Document where id in :strAttachmentIds];
        }
    }
}