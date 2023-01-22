public with sharing class FetchContactController {
    public FetchContactController() {

    }

    @AuraEnabled
    public static User getUserDetails(){
        String usrId = UserInfo.getUserId();
        User usr = [SELECT Id from User Where Id = :usrId];
        System.debug('Testt '+usr);
        return usr;
    }
}