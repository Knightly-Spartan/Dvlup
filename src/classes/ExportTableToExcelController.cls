public class ExportTableToExcelController {
    public Date startDate {get;set;}
    public Date endDate {get;set;}
    public Boolean showData {get;set;}
    public List<Account> accountList {get;set;}
    public List<Opportunity> opportunityList {get;set;}
    public List<dataWrapper> dataWrapperList {get;set;}  
    public List<Schema.FieldSetMember> accFieldSet { get; set; }
    public List<Schema.FieldSetMember> oppFieldSet { get; set; }
    
    //Constructor: initialize variables
    public ExportTableToExcelController() {
        showData = false; 
        accountList = new List<Account>();
        opportunityList = new List<Opportunity>();
        dataWrapperList = new List<dataWrapper>();  
    }
    
    //Method: To fetch the Data between the Opportunity's Actual Close Date range
    public void fetchData() {
        if (startDate!=null && endDate!=null) {
            showData = true;
            accFieldSet = SObjectType.Account.FieldSets.AccountFieldsToExport.getFields();
            oppFieldSet = SObjectType.Opportunity.FieldSets.OpportunityFieldsToExport.getFields();
            
            //Query Opportunities (,Opportunity Team Members and Opportunity Contact Roles) between the Actual Close Date range
            String oppQuery = 'SELECT ';
            for (Schema.FieldSetMember fld : oppFieldSet) {
                oppQuery += fld.getFieldPath() + ', ';
            }
            oppQuery += 'Id, AccountId, (SELECT Name, User.Name, TeamMemberRole FROM OpportunityTeamMembers Order By TeamMemberRole),';
            oppQuery += ' (Select Contact.Phone, Contact.Email, Role FROM OpportunityContactRoles Order By Role)';
            oppQuery += ' FROM Opportunity WHERE AccountId != null';
            oppQuery += ' AND CreatedDate > :startDate AND CreatedDate < :endDate Order By CreatedDate DESC';
            System.debug('oppQueryy ' + oppQuery);
            opportunityList = database.query(oppQuery);
            System.debug('opportunityListt '+opportunityList);
            
            if (opportunityList.size() > 0) {
                //Get the Issuer Account Ids from the Opportunities received 
                Set<Id> accountIds = new Set<Id>();
                for (Opportunity opp: opportunityList) {
                    if(opp.AccountId != null) {
                        accountIds.add(opp.AccountId);
                    }
                }
                
                //Query Issuer Accounts
                String accQuery = 'SELECT ';
                for (Schema.FieldSetMember fld : accFieldSet) {
                    accQuery += fld.getFieldPath() + ', ';
                }
                accQuery += 'Id FROM Account WHERE Id IN :accountIds';
                System.debug('accQueryy ' + accQuery);
                accountList = database.query(accQuery);
                System.debug('accountListt '+accountList);
                
                wrapData(accountList, opportunityList);
            }
        }
    }
    
    //Method: To render and export the Excel doc;
    public PageReference exportExcelSheet() {
        if (dataWrapperList.size() > 0) {
            PageReference pr = Page.ExportTableToExcelXML;
            pr.setRedirect(false);
            return pr;
        } else {
            return null;            
        }
    }  
    
    //Method: To wrap the Account, Opportunity and Opportunity Team Member data
    public void wrapData(List<Account> accList, List<Opportunity> oppList) {
        //Create dataWrapper instances and add to the dataWrapperList
        for (Opportunity opp : oppList) {
            for (Account acc : accList) {
                if (opp.AccountId == acc.Id) {
                    dataWrapperList.add(new dataWrapper(acc, opp));
                }
            }
        }
        System.debug('dataWrapperListt '+dataWrapperList);  
    }
    
    //Inner Class: Wrapper class to wrap Account, Opportunity and Opportunity Team Members
    public class dataWrapper {
        public Account acc {get; set;}
        public Opportunity opp {get; set;}
        //Constructor: For the wrapper class
        dataWrapper(Account acc, Opportunity opp) {
            this.acc = acc;
            this.opp = opp;
        }
    }
}