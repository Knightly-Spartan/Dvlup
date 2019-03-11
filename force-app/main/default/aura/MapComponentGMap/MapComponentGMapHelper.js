({
	formatJSON : function(rawjson) {
		var json = {}, key, loc, disp = [];
		for(var i in rawjson){
			key = rawjson[i].formatted_address;
			loc = L.latLng( rawjson[i].geometry.location.lat(), rawjson[i].geometry.location.lng() );
			json[ key ]= loc;	//key,value format
		}
		return json;
	},
    
    googleGeocoding : function(text, callResponse){
		geocoder.geocode({address: text}, callResponse);
	}
})