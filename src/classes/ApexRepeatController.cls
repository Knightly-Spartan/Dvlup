public class ApexRepeatController{
    public List<Account> accIdList {get; set;}

    public ApexRepeatController(){
     accIdList = [select Name, Phone from Account limit 10];
    }
}