public class MyToDoController {
	@AuraEnabled
    public static List<Task> getTasks() {
        return [Select Id, Subject, Status, ActivityDate From Task WHERE OwnerId = :UserInfo.getUserId()];
    }
}