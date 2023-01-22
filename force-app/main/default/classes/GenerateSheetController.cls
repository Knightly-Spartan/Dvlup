public class GenerateSheetController {
    public List<String> headers {get;set;}
    public Map<String, List<String>> objectFieldMap;
    public Map<String, List<sObject>> recordsMap {get;set;}
    
    public GenerateSheetController() {
        objectFieldMap = new Map<String, List<String>>();
		objectFieldMap.put('Account', new List<String>{'Id', 'Name'});
		objectFieldMap.put('Contact', new List<String>{'Id', 'Name'});
		generateSheet();
    }
    
    public Map<String, List<sObject>> generateSheet() {
        recordsMap = new Map<String, List<sObject>>();
        for (String obj : objectFieldMap.keySet()) {
            String query = 'SELECT ';
            query += String.join(objectFieldMap.get(obj), ',');
            query += ' FROM ' + obj + ' LIMIT 5';
            System.debug('Query: ' + query);
            recordsMap.put(obj, new List<Sobject>(Database.query(query)));
        }
        return recordsMap;
    }
}