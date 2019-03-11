public class ContactSearch {
    public static List<Contact> searchForContacts(string lastname, String postalcode) {
    List<Contact> contacts = [Select Id, Name
                             FROM Contact
                             WHERE LASTNAME = :lastname
                             AND MailingPostalCode = :postalcode];
                             
    return contacts;                       
    
    }


}