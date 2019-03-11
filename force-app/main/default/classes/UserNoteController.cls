public class UserNoteController {
	public User usr {get;set;}
	public Notes__c note {get;set;}
	public String userId {get;set;}
	public String accId {get;set;}
	public String noteId {get;set;}
	public List<SelectOption> accountList{get;set;}
	public List<SelectOption> noteList{get;set;}
	public boolean showDetails{get;set;}
	public UserNoteController(){
		showDetails = true;
		accountList = new List<SelectOption>();
		accountList.add(new SelectOption('','None'));
        String userId=ApexPages.currentPage().getParameters().get('aId');
        if(userId != null){
	        List<User> usrList= [SELECT Name, Id FROM User WHERE Id = :userId];
	        if(usrList.size() > 0) {
	            usr = usrList[0];
	        }
        }
        else{
        	userId = UserInfo.getUserId();
            List<User> usrList= [SELECT Name, Id FROM User WHERE Id = :userId];
        	if(usrList.size() > 0) {
            	usr = usrList[0];
       		}
        }
        for(Account acc : [Select Id, Name, AccountNumber from Account WHERE User__c = :userId]){
			accountList.add(new SelectOption(acc.Id,acc.Name));
		}
    }
    
    public void selected(){
		showDetails = true;
		noteList = new List<SelectOption>();
		noteList.add(new SelectOption('','None'));
		for(AccountNotes__c accnote : [SELECT Name, Id, Notes__r.Id, Notes__r.Title__c
                           				 FROM AccountNotes__c WHERE Account__c = :accId]){
				noteList.add(new SelectOption(accnote.Notes__r.Id, accnote.Notes__r.Title__c));
		}
		
    }
    
	public void selected2(){
		showDetails = true;
		List<Notes__c> noteList = [SELECT Name, Id, Title__c, Description__c, Private__c FROM Notes__c WHERE Id = :noteId];
	    if(noteList.size() > 0) {
	    	note = noteList[0];
	    }
	    showDetails = !note.Private__c;
	}
	
	public void edit() {
            if (note.Private__c) {                     
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Note is Private');
            ApexPages.addMessage(errMsg);
            }
            else {
            update note;
            ApexPages.Message okMsg = new ApexPages.Message(ApexPages.Severity.INFO,'INFO: Save Success');
            ApexPages.addMessage(okMsg);
            }
    }
}