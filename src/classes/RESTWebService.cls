@RestResource(urlMapping='/v1/MyWebService/*')
global with sharing class RESTWebService {
	// POST method that supports the creation of new cases Delegates responsibility to the createSupportCase() method.
    // The ReturnClass giving detail about the success or failure of the operation
    @HttpPost
    global static ReturnClass doPost(SupportCase supportCase){
        ReturnClass returnClass = createSupportCase(supportCase);
        return returnClass;
    }
    
    // If successful, the newly created Case Id will be shown, else an informative error will be presented.
    private static ReturnClass createSupportCase(SupportCase supportCase) {
        ReturnClass returnClass = new ReturnClass();
        
        // Set savepoint to roll back to if there are any errors.
        // If anything goes wrong, we will roll back and present to the user to fix the issue
        Savepoint sp = Database.setSavepoint();
        
        try {
            // Create new Case 
            Case newCase = new Case();
            
            newCase = supportCase.caseToInsert;
            
            // Insert the Case
            insert newCase;
            
            returnClass.success = true;
            returnClass.message = newCase.Id;
            return returnClass;
        } catch(Exception e) {
            // If any errors occur - Rollback any dmls
            Database.rollback(sp);
            
            // Set up the failure return object
            returnClass.success = false;
            returnClass.message = e.getMessage();
			RestContext.response.statusCode = 400;            
            // Exit and return to user
            return returnClass;
        }
    }
    
    // Class that models the incoming Support Case and related objects request.
    global class SupportCase {
        public Case caseToInsert;
    }
    
    // Class that models the response to the request to create a Case
    global class ReturnClass {
        global boolean success = false;
        global String message;
    }
}