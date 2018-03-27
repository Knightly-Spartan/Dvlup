//
// (c) 2012 Appirio, Inc.
//
// Utility class to process EmailTemplate and merge record field values
//
// 1 March  2013          Appirio - Sudhir Kr. Jagetiya             Original - Asset
// 7 December 2016		  Amit Sanwariya (Appirio)					Modified - For Send Email T-548021
//
public without sharing class TemplateUtil {
    static String Link = 'link';
    static Map <String,String> TemplateOwnerFields {
    get{
        if(TemplateOwnerFields == null){
            TemplateOwnerFields = new Map <String,String>();
            TemplateOwnerFields.put('ownerfullname','owner.Name');
            TemplateOwnerFields.put('ownerfirstname','owner.firstname');
            TemplateOwnerFields.put('ownerlastname','owner.lastname');
            TemplateOwnerFields.put('ownerphone','owner.phone');
            TemplateOwnerFields.put('ownertitle','owner.title');
            TemplateOwnerFields.put('owneremail','owner.email');
        }
        return TemplateOwnerFields; 
    }
      set;
    }
    public static Map<String,Map<String, Schema.SObjectField>> GlobalObjectFieldList {get;set;}

    //queries template and merges values and returns merged email template
    public static EmailTemplate GetMail(Id templateId, Id recordId) {
        EmailTemplate emailTemplate;
        String brandTemplateString = '';
        for(EmailTemplate eTemp:[select Id, Subject,DeveloperName, body,HtmlValue, TemplateType,BrandTemplateId from EmailTemplate 
                                 where id = :templateId]) {
            emailTemplate = eTemp;
        }
        //Fetching the brand template value....
        if(emailTemplate.BrandTemplateId != null) {
            for(BrandTemplate bTemp : [select Value from BrandTemplate where id = :emailTemplate.BrandTemplateId]) {
                brandTemplateString = bTemp.Value;
            }
        }
        return getMergedTemplate(emailTemplate,recordId,brandTemplateString);    
    }

    //merge record values in string
    private static string mergeValues(String srcString,Map<String,Set<String>> mapFields,Map<String,sObject> mapRecords) {
        for(String objectName : mapFields.keySet()) {
            Set<String> fieldSet = mapFields.get(objectName);
            sObject record = mapRecords.get(objectName);
            for(String field : fieldSet) {
            String fieldString = objectName + '.' + field;
                if(srcString != Null && srcString.contains(fieldString)) {
                    field = TemplateOwnerFields.containsKey(field.toLowerCase())? TemplateOwnerFields.get(field.toLowerCase()) : field;
                    String val = record != null ? getObjectFieldValue(field,record) : '';
                    srcString = srcString.replace('{!' + fieldString + '}',val);
                }
            }   
        }
        return srcString;
    }

    //merge record values in template
    private static EmailTemplate getMergedTemplate(EmailTemplate emailTemplate, Id recordId,String emailHeaderFooter) {
        
        if(recordId == null) {
            emailTemplate.htmlValue = emailTemplate.htmlValue.replace('<![CDATA[','').replace(']]>','');
            return emailTemplate;
        }          

        Map<String,Set<String>> mapFields = getFieldMapping(generateFieldSet(emailTemplate));
        Map<String,sObject> mapRecords = getRecordMapping(mapFields,recordId);
        String htmlValue = mergeValues((emailTemplate.TemplateType.toLowerCase() == 'text' ? emailTemplate.body : emailTemplate.HtmlValue),mapFields,mapRecords);

        if(emailHeaderFooter.contains('<style color="#000000" font-size="12pt" background-color="#FFFFFF" font-family="arial" bLabel="main" bEditID="r3st1" >')) {
            //Fomatting letter head
            emailHeaderFooter = editLetterHeadFormat(emailHeaderFooter);
            htmlValue = emailHeaderFooter.replace('<style color="#000000" font-size="12pt" background-color="#FFFFFF" font-family="arial" bLabel="main" bEditID="r3st1" >',htmlValue);
        }
        htmlValue = htmlValue.replace('<![CDATA[','').replace(']]>','');
        return new EmailTemplate(TemplateType = emailTemplate.TemplateType, subject = mergeValues(emailTemplate.subject,mapFields,mapRecords), htmlValue = htmlValue );
    }
    
    //To format and merge letterhead html
    private static String editLetterHeadFormat(String emailHeaderFooter) {
        Integer index = 0;
        //Replacing <img> tag's innertHTML in it's src attribute
        while(index >= 0) {
            String imgUrl = '';
            index = emailHeaderFooter.indexOf('<img',index);
            if(index >= 0) {
                index = emailHeaderFooter.indexOf('>',index);
                if(emailHeaderFooter.indexOf('</img',index) > 0) {
                    imgUrl = emailHeaderFooter.substring(index+1,emailHeaderFooter.indexOf('</img',index));
                    if(imgUrl.trim().length() > 0) {
                        index = emailHeaderFooter.indexOf('</img',index);
                        index = index - (imgUrl.length()+ 1);
                        emailHeaderFooter = emailHeaderFooter.replace(imgUrl,'');
                        emailHeaderFooter = emailHeaderFooter.substring(0,index) + ' src="'+imgUrl+'"'+emailHeaderFooter.substring(index+1);
                    }
                }
            }
            break;
        }
        //Replacing td's inner HTML if it's a style tag and insert it in style of td itself
        index = 400;
        Integer tdIndex = 0;
        while(index > 0) {
            index = emailHeaderFooter.indexOf('<td',index);
            if(index > 0) {
                tdIndex = index;
                if(emailHeaderFooter.indexOf('<style',index) > 0)   {
                    index = emailHeaderFooter.indexOf('<style',index);
                    if(emailHeaderFooter.indexOf('>',index) > 0) {
                        Integer startIndex = 0;
                        Integer endingIndex = 0;
                        startIndex = index;
                        index = emailHeaderFooter.indexOf('>',index)+1;
                        endingIndex = index;
                        String style = emailHeaderFooter.substring(startIndex+7,endingIndex-1);
                        emailHeaderFooter = emailHeaderFooter.substring(0,tdIndex+4)+ 'style="'+style.replace('="',':').replace('"',';')+'"'+emailHeaderFooter.substring(tdIndex+5);
                    }
                }
            }           
        }
        return emailHeaderFooter;
    }
    //prepares field set for email template
    private static Set<String> generateFieldSet(EmailTemplate emailTemplate) {
        Set<String> fieldSet = new Set<String>();
        if(emailTemplate.subject.contains('{')){
            fieldSet.addAll(getObjectInfo(emailTemplate.subject));
        }
        if(emailTemplate.TemplateType.toLowerCase() == 'text' && emailTemplate.body.contains('{')){
            fieldSet.addAll(getObjectInfo(emailTemplate.body));
        }
        if(emailTemplate.TemplateType.toLowerCase() == 'html' && emailTemplate.HtmlValue.contains('{')){
            fieldSet.addAll(getObjectInfo(emailTemplate.HtmlValue));
        }
        return fieldSet;
    }

    //process string and prepares a list of fields 
    private static Set<String> getObjectInfo(string content) {
        Set<String> fieldSet = new Set<String>();
        integer index = 0;
        integer lastIndex=0;
        if(content.contains('{')){
            while(content.contains('{')){
                index = content.indexOf('{')+1;
            content = content.substring(index);
            if(content.substring(0, 1) == '!'){
                lastIndex = content.indexOf('}');
                fieldSet.Add(content.substring(1, lastIndex));
            }
            if(content.length()-1 != lastIndex){
                content = content.substring(lastIndex+1);
            }
            else 
                break;
            }
        }
        return fieldSet;
    }

    //processes all fields and prepares a map of fields with object
    private static Map<String,Set<String>> getFieldMapping(Set<String> fieldSet){
        Map<String,Set<String>>  mapFields = new Map<String,Set<String>>();
        for(String field : fieldSet){
            String[] fieldParts = field.replace('.','-').split('-');
            if(fieldParts.size() > 0){
                if(!mapFields.containsKey(fieldParts[0]))
                    mapFields.put(fieldParts[0],new Set<String>());
                    mapFields.get(fieldParts[0]).add(fieldParts[1]);
                }   
            }      
        return mapFields;
    }

    //retrieve record and put it into the MAP with object name as keyset 
    private static Map<String,sObject> getRecordMapping(Map<String,Set<String>>  mapFields,Id recordId) {
        Map<String,sObject> mapRecords = new Map<String,sObject>();     
        
        //prepares query for each set and retrieve record
        for(String objectName : mapFields.keySet()) {
            Set<String> fieldSet = mapFields.get(objectName);
            String query = '';
            for(String field : fieldSet){
                if(!field.equalsIgnoreCase(Link)) {              
                    query += query.trim().length()== 0? getObjectFieldName(field,objectName) : (getObjectFieldName(field,objectName) != '' ?(',' + getObjectFieldName(field,objectName)) : '');
                } 
            }

            if(query != '')
                query = 'Select ' + query + ' from ' + objectName + ' where id = \''+ recordId + '\' Limit 1';
                List<sObject> records = database.query(query);
                if(records.size() > 0) {
                    mapRecords.put(objectName,records.get(0));
                }   
            }
        return mapRecords;
    }  

    //get API name for query 
    private static String getObjectFieldName(String templateFieldName,String objectName) {
        //Get field map for the record object
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(objectName);
        if(fieldMap != null) {
            //if templateFieldName is ay of owner fields
            if(TemplateOwnerFields.containsKey(templateFieldName.toLowerCase()))
                return TemplateOwnerFields.get(templateFieldName.toLowerCase());
            
            if(!fieldMap.containsKey(templateFieldName)){
                if(templateFieldName.indexOf('Id__c') >= 0)
                    return templateFieldName.replace('Id__c','__c');
            else {
                fieldMap = getFieldMap(templateFieldName);
                if(fieldMap != NULL && fieldMap.containsKey('name'))
                    return templateFieldName + '.Name';
                else
                    return '';
            }        
            } else {
                String dataType = String.valueOf(fieldMap.get(templateFieldName).getDescribe().getSoapType()); 
                if(templateFieldName.indexOf('__c') >= 0 && dataType.equalsIgnoreCase('ID'))
                    return templateFieldName.replace('__c','__r') + '.Name';
                return templateFieldName;
            }
        }
        return '';
    }
    
    //get value of templateFieldName in record
    private static String getObjectFieldValue(String templateFieldName,sObject record) {
        //Handle Detial Link field
        if(templateFieldName.equalsIgnoreCase(Link))
            return 'https://' + ApexPages.currentPage().getHeaders().get('Host') + '/' + record.get('Id');

        //Get field map for the record object
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(String.valueOf(record.getsObjectType()));
        if(fieldMap != null) {
            //templateFieldName matches with object field
            if(fieldMap.containsKey(templateFieldName)){
                String dataType = String.valueOf(fieldMap.get(templateFieldName).getDescribe().getSoapType()); 
                if(templateFieldName.indexOf('__c') >= 0 && dataType.equalsIgnoreCase('ID')){            
                    record = record.getSObject(templateFieldName.replace('__c','__r'));
                    return record != null ? (String)record.get('Name') : ''; 
                }       
             return record.get(templateFieldName) != null ? String.valueOf(record.get(templateFieldName)) : '';
            }            
                
            // if templateFieldName doesn't match with object field then check if it is ID field
            if(templateFieldName.indexOf('Id__c') >= 0){
                templateFieldName = templateFieldName.replace('Id__c','__c');
                return record.get(templateFieldName) != null ? String.valueOf(record.get(templateFieldName)) : '';
            }
                
            //templateFieldName contain '.' call this method recursively for referred object
            if(templateFieldName.indexOf('.') >= 0){
                String[] fields = templateFieldName.replace('.','-').split('-');
                return getObjectFieldValue(templateFieldName.replace(fields[0] + '.',''),record.getSObject(fields[0]));
            }
                
            //if none of above case
            fieldMap = getFieldMap(templateFieldName);
            if(fieldMap != Null) { 
                record = record.getSObject(templateFieldName);
                return record != null ? (String)record.get('Name') : '';
            }
        }
        return '';
    }

    //Call GlobalDescribe to get fields for objType and add it in GlobalObjectFieldList
    private static Map<String, Schema.SObjectField> getFieldMap(String objType) {
        objType = objType.toLowerCase();                

        if(GlobalObjectFieldList == null)
            GlobalObjectFieldList = new Map<String,Map<String, Schema.SObjectField>>();

        if(!GlobalObjectFieldList.containsKey(objType)) {
            Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
            if(gd.containsKey(objType)) {
                GlobalObjectFieldList.put(objType,gd.get(objType).getDescribe().fields.getMap());
            } 
        }           
        return GlobalObjectFieldList.get(objType);
    }

}