<aura:application >
    <!-- Loading Libraries -->
    <script src="/resource/requireJS" ></script> 
    <link href='/resource/Resources/resources/bootstrap3/dist/css/bootstrap.css' rel="stylesheet"/>
    <aura:handler event="c:RequireJsEvent" action="{!c.initJS}"/>
    <aura:registerEvent type="c:RequireJsEvent" name="c:RequireJSEvent"/> 
	<aura:handler name="init" value="{!this}" action="{!c.doInit}" />
    <!-- Loading the component for Questions and graph -->
    <c:Questions />
</aura:application>