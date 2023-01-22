public class CustomVFPageController {
    public static List<Contact> contacts {get;set;}
    public static String searchKey {get;set;}
    
    public CustomVFPageController() {
     	contacts = [Select FirstName, LastName, Email FROM Contact WHERE FirstName LIKE :searchKey];  
    }
	
    public static void search() {
        searchKey = '%'+searchKey+'%';
     	contacts = [Select FirstName, LastName, Email FROM Contact WHERE FirstName LIKE :searchKey];  
    }
}