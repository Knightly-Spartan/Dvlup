public class CandidateTriggerHandler {

    public void beforeInsert(List<Candidate__c> candidateList) {
        calculateAge(candidateList);
        validateDuplicateCandidateRecord(candidateList);
    }
    
    public void beforeUpdate(List<Candidate__C> candidateList, Map<Id, Candidate__c> oldCandidateMap) {
        calculateAge(candidateList, oldCandidateMap);
        validateDuplicateCandidateRecord(candidateList, oldCandidateMap);
    }
    
    public void validateDuplicateCandidateRecord (List<Candidate__c> candidateList) {
        
        Set<string> firstName = new Set<string>();
        Set<string> email = new Set<string>();
        Set<string> phone = new Set<string>();     
        
        for (Candidate__c can : candidateList) {
            firstName.add(can.First_Name__c);
            email.add(can.Email__c);
            phone.add(can.Mobile__c);
        }
        
        Set<String> existingCandidateSet = new Set<String>();
            
        for (Candidate__c can: [SELECT Id ,First_Name__c ,Mobile__c ,Email__c
                               	FROM Candidate__c 
                               	WHERE First_Name__c IN :firstName 
                               	AND Mobile__c IN :phone 
                               	AND Email__c IN :email]) {
            existingCandidateSet.add(can.First_Name__c+can.Email__c+can.Mobile__c);
        }
        
        for (Candidate__c can : candidateList) {
            string temp = can.First_Name__c+can.Email__c+can.Mobile__c;
            if(existingCandidateSet.contains(temp)) {
                can.addError('Duplicate Record');
            } else {
                existingCandidateSet.add(temp);
            }
        } 
    }
    
    public void validateDuplicateCandidateRecord (List<Candidate__c> candidateList, Map<Id, Candidate__c> oldCandidateMap) {
        for (Candidate__c can : candidateList) {
            if (can.First_Name__c != oldCandidateMap.get(can.Id).First_Name__c
               || can.Email__c != oldCandidateMap.get(can.Id).Email__c
               || can.Mobile__c != oldCandidateMap.get(can.Id).Mobile__c) {
                validateDuplicateCandidateRecord(candidateList);
            }
        }
    }
    
    public static void calculateAge (List<Candidate__c> candidateList) {
        for (Candidate__c can : candidateList) {
            if (can.Date_Of_Birth__c != null) {
                can.Age__c = can.Date_Of_Birth__c.daysBetween(System.today())/365;
            } else if (can.Date_Of_Birth__c == null) {
                can.Date_Of_Birth__c.addError(Label.DOB_Can_t_Be_Null);
            }
        }
    }
    
    public static void calculateAge(List<Candidate__c> candidateList, Map<Id, Candidate__c> oldCandidateMap) {
        for(Candidate__c can : candidateList) {
            if(can.Date_Of_Birth__c != oldCandidateMap.get(can.Id).Date_Of_Birth__c
              	&& can.Date_Of_Birth__c != null) {
                can.Age__c = can.Date_Of_Birth__c.daysBetween(System.today())/365;
            } else if (can.Date_Of_Birth__c == null) {
                can.Date_Of_Birth__c.addError(Label.DOB_Can_t_Be_Null);
            }
		}
    }
}