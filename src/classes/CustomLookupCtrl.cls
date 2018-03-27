// (c) 2012 Appirio, Inc.
//
// CustomLookupCtrl
// Lookup for additional email,cc and bcc. 
//
// Original Appirio Asset
// 17 October 2016      Amit Sanwariya    			 	Modified - For Send Email T-548021
//
public without sharing class CustomLookupCtrl {
	public String fieldName {get;set;}   
    public String objName {get;set;}
    public String selectedId {get;set;}
    public SObject currentRecord{get;set;}
    public String selectedRecordName {get;set;}
    public String fieldPopulatingId {get;set;}
    public String fieldSetAPIName {get;set;}
    public List<sObject> listRecords {get;set;}
    public List<String> listFieldNames {get; set;}
    public String searchText {get;set;}
                  
    public CustomLookupCtrl(){
    	fieldName = '';
    	objName = '';
    	currentRecord = null;
    	listRecords = new List<sObject>();        
    }
     
    public void getSelectedRecord(){
    	if(selectedId != null && selectedId != ''){                 
    		string currentRecordId = selectedId;     	
    		if(currentRecordId <> null){
		    	List<Sobject> sobjectList = Database.query('SELECT Id, ' + fieldName + ' FROM ' + objName + ' WHERE ID = : currentRecordId');
		    	
		    	if(!sobjectList.isEmpty()){
		    		currentRecord = sobjectList[0];
		    		selectedRecordName = (String) sobjectList[0].get('Name');
		    	}
    		}
    	}
    }
    
	public void OpenLookupPopupCntrl(){
    	runSearch();
    }
    
    /********************************************************************************************************************
    * Method to run the search with parameters passed via Page Parameters
    *********************************************************************************************************************/
    public void runSearch() {
        String fieldsToFetch = getFieldsForSelectedObject();
        String whereClause = ''; 
        if(fieldsToFetch != null && fieldsToFetch != ''){
	        String searchString = 'Select Id, Name, ' + fieldsToFetch + ' From ' + objName;
	        if(searchText != '' && searchText != null){
	        	whereClause = ' Where Email != null AND ' + fieldName  + ' LIKE \'%' + String.escapeSingleQuotes(searchText)+'%\'';
	        }
	        listRecords = Database.query(searchString + whereClause + ' order by Name limit 50');
        }
    }
    
    /********************************************************************************************************************
    * Method to Get all Fields of the selected object
    *********************************************************************************************************************/
    public String getFieldsForSelectedObject(){    
       listFieldNames = new List<String>(); 
       List<Schema.FieldSetMember> fieldSetMemberList = new List<Schema.FieldSetMember>();
       String fieldsToFetch = '';
       try{
           if(objName != null && objName != ''){             

               	Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
			    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(objName);
			    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
			    
			    if(DescribeSObjectResultObj.FieldSets.getMap().ContainsKey(fieldSetAPIName)){
			    	Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetAPIName);
				    fieldSetMemberList =  fieldSetObj.getFields(); 
			    }
			    
			    for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
				{
    				listFieldNames.add(string.ValueOf(fieldSetMemberObj.getFieldPath()));
				}
            }
           
           //Building Query with the fields
			Integer i = 0; 
			Integer len = listFieldNames.size();
			for(String temp:listFieldNames){
				if(i==len-1){
					fieldsToFetch = fieldsToFetch + temp;
				} else {
					fieldsToFetch = fieldsToFetch + temp + ',';
				}
				i++;
			}
        }catch(Exception ex){          
            apexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'There is no Field for selected Object!'));
        }           
        return fieldsToFetch;
    }    
}