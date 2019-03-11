@Istest(SeeAllData=true)
public class AccountManagerTest {
    

    
    @IsTest
    public static void testaccountmanager() {
        RestRequest request = new RestRequest();
        request.requestUri = 'https://spartan-dev-ed.my.salesforce.com/services/apexrest/Accounts/0012800000C5VJlAAN/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        
		system.debug('Test Accounts '+ AccountManager.getAccount());


        
    }
    

}