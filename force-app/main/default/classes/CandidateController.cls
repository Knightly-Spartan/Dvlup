public class CandidateController {
    
    public class CandidateWrapper {
        string candidateName = '';
        string jobAppName = '';
        string hiringManagerName = '';
    }
    public void fetchData() {
        CandidateWrapper canObj;
        List<CandidateWrapper> wrapObj = new List<CandidateWrapper>();
        Map<String, List<CandidateWrapper>> mapCanWrap = new Map<String, List<CandidateWrapper>>();
     	List<SelectOption> listCity = new List<SelectOption>();
        
    	for(Candidate__c can : [SELECT Name, City__c,
                               		(SELECT Name, Position__r.Hiring_Manager__r.FirstName
                                 	 FROM Job_Applications__r)
                                FROM Candidate__c]) 
        {                        
        	for(Job_Application__c ja : can.Job_Applications__r) {
            	canObj = new CandidateWrapper();
                canObj.candidateName = can.Name;
                canObj.jobAppName = ja.Name;
        		canObj.hiringManagerName = ja.Position__r.Hiring_Manager__r.FirstName;
                wrapObj.add(canObj);
        	}
            
            if(!mapCanWrap.containsKey(can.City__C)) {
            	mapCanWrap.put(can.City__c, new List<CandidateWrapper>());
                listCity.add(new SelectOption(can.City__c, can.City__c));
            }
            mapCanWrap.get(can.City__c).addAll(wrapObj);  
    	}
    }
}