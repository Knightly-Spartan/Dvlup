public with sharing class NotesController {

    public Id userId { get; set; }
    public Id parentId { get; set; }
    public Id selectedId { get; set; }
    public Account acc { get; set; }
    public Contact con { get; set; }
    public Opportunity opp { get; set; }
    public Notes__c note { get; set; }
    public Boolean showObject { get; set; } 
    public Boolean showDetails { get; set; }
    public Boolean isAccount { get; set; }
    public Boolean isContact { get; set; }
    public Boolean isOpportunity { get; set; }
    public Boolean editOwner { get; set; }
    public List<SelectOption> selectList { get; set; }
    
    public NotesController() {
        showObject = false;
        showDetails = false;
        isAccount = false;
        isContact = false;
        isOpportunity = false;
        editOwner = false;
        selectList = new List<SelectOption>();
        
        note = new Notes__c();
        
        userId=ApexPages.currentPage().getParameters().get('uId');
        if ( userId == null ){
          userId = UserInfo.getUserId(); 
        }
        List<User> usrList= [ SELECT Name, Id FROM User WHERE Id = :userId ];
        if ( usrList.size() > 0 ) {
            note.Record_Owner__c = userId;
        } else {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: User Id Incorrect');
            ApexPages.addMessage(errMsg);
        }
        
        parentId=ApexPages.currentPage().getParameters().get('pId');
        if ( parentId != null ){
          List<Account> accList = [ SELECT Name, Id FROM Account WHERE Id = :parentId ];
          List<Contact> conList = [ SELECT Name, Id FROM Contact WHERE Id = :parentId ];
          List<Opportunity> oppList = [ SELECT Name, Id FROM Opportunity WHERE Id = :parentId ];
          if ( accList.size() > 0 ) {
              accountNote();
          } else if ( conList.size() > 0 ) {
              contactNote();
          } else if ( oppList.size() > 0 ) {
              opportunityNote();
          } else { 
              ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Parent Object Id Required');
              ApexPages.addMessage(errMsg);
          }
        } else {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Parent Id Incorrect');
            ApexPages.addMessage(errMsg);
        }
    }
    
    public void accountNote() {
        isAccount = true;
        note.Account__c = parentId;
        List<Account> accList = [ SELECT Id, Name FROM Account WHERE OwnerId = :userId ];
        for(Account acc : accList) {
            selectList.add( new SelectOption(acc.Id, acc.Name));
        }
    }
    
    public void contactNote() {
        isContact = true;
        note.Contact__c = parentId;  
        List<Contact> conList = [ SELECT Id, Name FROM Contact WHERE OwnerId = :userId ];
        for(Contact con : conList) {
            selectList.add( new SelectOption(con.Id, con.Name));
        }
    }
    
    public void opportunityNote() {
        isOpportunity = true;
        note.Opportunity__c = parentId;
        List<Opportunity> oppList = [ SELECT Id, Name FROM Opportunity WHERE OwnerId = :userId ];
        for(Opportunity opp : oppList) {
            selectList.add( new SelectOption(opp.Id, opp.Name));
        }  
    }
    
    public void Save() {
        if ( Validate() ) {
            showDetails = true;
            insert note;
        } else {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Date and Description are Required');
            ApexPages.addMessage(errMsg);
        }
    }
    
    public void Reset() {
        editOwner = true;
    }
    
    public boolean Validate() {
        if ( note.Date__c == null || note.Description__c == null ) {
            return false;
        }
        else {
            return true;
        }
    }
    
    public void selectObject() {
        system.debug('hello');
        showObject = true;
        List<Account> accList = [ SELECT Name, Id, Owner.Name FROM Account WHERE Id = :selectedId  ];
        List<Contact> conList = [ SELECT Name, Id, Owner.Name FROM Contact WHERE Id = :selectedId  ];
        List<Opportunity> oppList = [ SELECT Name, Id, Owner.Name FROM Opportunity WHERE Id = :selectedId  ];
        if ( accList.size() > 0 ) {
            acc = accList[0];
        } else if ( conList.size() > 0 ) {
            con = conList[0];
        } else if ( oppList.size() > 0 ) {
            opp = oppList[0];
        }
    }
}