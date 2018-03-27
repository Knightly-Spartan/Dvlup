public class AccountHandler {
    public static Account insertNewAccount (String accName){ 
    if(accName!=''){   
        try{
            Account a = new Account(Name=accName);
            insert a;
            System.debug('Good Job Amit! Account created');
            return a;
        } catch(Exception e){
            System.Debug('Account not created');
            return null;
        }
    } else {
        return null; 
    }
  }    
}