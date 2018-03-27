public with sharing class RadiusMapController {

	public decimal radius { get;set; }
    public decimal lat { get;set; }
    public decimal lon { get;set; }
    public String query; 
    public List<Contact> contactsXML { get;set;}
    
    //Method to find Influencers around a given geolocation in a radius
    public void filterXML() {
        if ( apexpages.currentpage().getparameters().get( 'rad' ) != null ) {
            radius = Decimal.valueOf( apexpages.currentpage().getparameters().get( 'rad' ) );
            lat = Decimal.valueOf( apexpages.currentpage().getparameters().get( 'lat' ) );
            lon = Decimal.valueOf( apexpages.currentpage().getparameters().get( 'lon' ) );
        }
        
        query = 'SELECT Id, Name, Email, Phone, AccountId, Location__c, Location__latitude__s, Location__longitude__s' + 
                        ' FROM Contact' + 
                        ' WHERE DISTANCE( Contact.Location__c, GEOLOCATION( ' + lat + ', ' + lon + ' ), \'mi\' ) < ' + radius + 
                        ' ORDER BY DISTANCE( Contact.Location__c, GEOLOCATION( ' + lat + ', ' + lon + ' ), \'mi\' )';
        system.debug( '>>>' + radius + ' ' + lat + ' ' + lon);
        contactsXML = Database.query( query );
    }
}