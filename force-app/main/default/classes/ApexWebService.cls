@RestResource(urlMapping='/v1/apexservice/*')
global class ApexWebService {
	
    @HttpPost
    global static void createAccount(String name) {
        Account acc = new Account(Name=name);
        insert acc;
        
        ReturnClass returnClass = new ReturnClass();
        returnClass.success = true;
        returnClass.message = 'Account Insert Successfully Id: '+acc.Id;
        
        RestResponse res = RestContext.response;
        if (res == null) {
            res = new RestResponse();
            RestContext.response = res;
        }
        
        // Return something
        res.responseBody = Blob.valueOf(JSON.serialize(returnClass));
        
        // Set the status
        res.statusCode = 201;
        
        
        //return res;
    }
    
    // Class that models the response to the request to create a Case
    global class ReturnClass {
        global boolean success = false;
        global String message;
    }
}