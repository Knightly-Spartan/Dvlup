@isTest
public class ParentFieldsTest {
	@isTest private static void testParentFields() {
        Account acc =  new Account(Name = 'TestAccount');
        insert acc;
        Contact con = new Contact(LastName ='Last' ,
                                  AccountId = acc.Id);
        insert con;
        Test.startTest();
            ApexPages.StandardController sc = new ApexPages.StandardController(con);
            ParentFieldsExtension extension = new ParentFieldsExtension(sc);
            System.assert(extension.accFieldSet.size() > 0);
            sc = new ApexPages.StandardController(con);
        Test.stopTest();
	}  
}