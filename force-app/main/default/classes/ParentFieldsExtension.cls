public class ParentFieldsExtension {
	public Id conId { get; set; }
    public Id accId { get; set; }
    public Contact con { get; set; }
    public Account acc { get; set; }
    public List<Schema.FieldSetMember> accFieldSet { get; set; }
    
    //Constructor for fetching the Parent Account field values
    public ParentFieldsExtension(ApexPages.StandardController controller) {
        conId = controller.getId();
        system.debug('ContactId'+conId);
        con = [SELECT Id, Name, AccountId FROM Contact WHERE Id = :conId];
        accId = con.AccountId;
        system.debug('AccountId '+accId);
        if ( String.IsEmpty(accId) ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Account lookup is empty'));
        } else {
        	accFieldSet = SObjectType.Account.FieldSets.AccountFieldsForContact.getFields();
            String query = 'SELECT ';
            for (Schema.FieldSetMember fld : accFieldSet) {
                query += fld.getFieldPath() + ', ';
            }
            query += 'Id, Name FROM Account WHERE Id = :accId';
            acc = database.query(query);
        }
    }
}