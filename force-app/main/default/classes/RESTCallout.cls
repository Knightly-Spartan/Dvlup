public class RESTCallout {
    public static void testCallout(){
        String endPoint = 'https://login.salesforce.com/services/oauth2/token?grant_type=password&client_id=3MVG9ZL0ppGP5UrBIUp0vVLlmH2rKsrHFmKp7sTuFoWZTX.d6DzvCkWa.r4PWNxHpoRp2n4zRCslE2CF7myKg&client_secret=8686829578426679790&username=amitsanwariya@outlook.com&password=S2k@1017EH9lXdyWlTQHJEnqNSYKjLCP';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            AccessTokenWrapper atWrap = AccessTokenWrapper.parse(response.getBody());
            
            System.debug('TokenResponse '+atWrap);
            createAccountCallout(atWrap.access_token, atWrap.instance_url);
        }
    }
    
    public static void createAccountCallout(String accessToken, String instanceURL){
        String endPoint = instanceURL+'/services/apexrest/v1/apexservice/';
        Account acc = new Account(Name='Test Account'); 
        String body = '{"name" : "Bigfoot Sighting!"}';
        
        System.debug('Request body '+body);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer '+accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug('DataResponse '+response.getStatusCode());
        System.debug('DataResponse '+response.getBody());
    }
}