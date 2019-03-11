({
    rerender: function (component, helper) {

        var nodes = this.superRerender();
        // If Leaflet library is not yet loaded, we can't draw the map: return
        if (!window.L) return nodes;
        var map = component.get("v.map");
        // Draw the map if it hasn't been drawn yet
        if (!map) {
            
            var geocoder = new window.google.maps.Geocoder();
            component.set("v.geocoder", geocoder);
            
            var mapElement = component.find("map").getElement();
            map = new window.L.Map(mapElement, {zoom: 9, center: new L.latLng([41.575730,13.002411]) });
            map.addLayer(new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'));	//base layer   
            map.addControl( new L.Control.Search({
                            sourceData: helper.googleGeocoding,
                            formatData: helper.formatJSON,
                            markerLocation: true,
                            autoType: false,
                            autoCollapse: true,
                            minLength: 2,
                            zoom: 10})
                      );
			component.set("v.map", map);  
        }
        return nodes;

    }
})