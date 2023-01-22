public class ServerSideActionController {
	@AuraEnabled
    public static List<Account> getExpenses(String name) {
        String nameKey = '%'+name+'%';
        return [SELECT Id, Name, Phone, Type FROM Account WHERE Name LIKE :nameKey LIMIT 10];
    }
}