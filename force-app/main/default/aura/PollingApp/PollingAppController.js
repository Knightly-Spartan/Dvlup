({
	/*
    	Sets up the RequireJS library (async load)
    */
    doInit : function(component, event, helper){
        
        if (typeof require !== "undefined") {
            var evt = $A.get("e.pets:RequireJSEvent");
		    evt.fire();
        } else {
            var head = document.getElementsByTagName('head')[0];
            var script = document.createElement('script');
            
            script.src = "/resource/RequireJS"; 
            script.type = 'text/javascript';
            script.key = "/resource/RequireJS"; 
            script.helper = this;
            script.id = "script_" + component.getGlobalId();
            var hlp = helper;
            script.onload = function scriptLoaded(){
                var evt = $A.get("e.pets:RequireJSEvent");
		        evt.fire();
            };
            head.appendChild(script);
        }
    },
    
    initJS : function(component, event, helper){
        require.config({
            paths: {
                "jquery": "/resource/Resources/resources/jQuery.js?",
                "HighChart": "/resource/Resources/resources/HighChart/js/highcharts.js?",
                "HighChart-more": "/resource/Resources/resources/HighChart/js/highcharts-more.js?",
                "exporting": "/resource/Resources/resources/HighChart/js/modules/exporting.js?",
                "bootstrap": "/resource/Resources/resources/bootstrap3/dist/js/bootstrap.js?"
            }
        });
        console.log("RequiresJS has been loaded? "+(require !== "undefined"));
        //loading libraries sequentially
        require(["jquery"], function($) {
            console.log("jQuery has been loaded? "+($ !== "undefined"));
            require(["HighChart"], function(HighChart) {
                console.log("HighChart has been loaded? "+(HighChart !== "undefined"));
                $("#afterLoad").html("VALUE CHANGED!!!");
            });//require end
        });//require end
    }
})