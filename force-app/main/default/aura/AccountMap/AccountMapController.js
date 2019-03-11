({
jsLoaded: function(component, event, helper) {
    setTimeout(function() {
        var map = L.map('map').setView([37.784173, -122.401557], 14);
        L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
            {
                attribution: 'Tiles © Esri'
            }).addTo(map);
		
        //L.Control.Search({layer: searchLayer}).addTo(map);
        //map.addControl( new L.Control.Search({layer: searchLayer}) );
        //Add search
        /*
        new L.Control.GeoSearch({
    	provider: new L.GeoSearch.Provider.OpenStreetMap(),
    	position: 'topcenter',
    	showMarker: true,
   		retainZoomLevel: false,
		}).addTo(map);
        */
        
        // Add marker
        L.marker([37.784173, -122.401557]).addTo(map)
            .bindPopup('Home of Dreamforce');
        });
}
})