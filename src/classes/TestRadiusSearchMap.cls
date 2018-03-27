@isTest
private class TestRadiusSearchMap { 
	//Create an object of the controller class and run the methods
    static testMethod void testGetParam() {
       RadiusMapController controller = new RadiusMapController();
       PageReference pr = Page.RadiusMapXMLFilter;
       Test.setCurrentPage(pr);
       apexpages.currentpage().getparameters().put( 'rad' , '10');
       apexpages.currentpage().getparameters().put( 'lat' , '1.1');
       apexpages.currentpage().getparameters().put( 'lon' , '1.1');
       controller.filterXML();
       controller.radius = 10;
       controller.lat = 1.1;
       controller.lon = 1.1;
    }
}