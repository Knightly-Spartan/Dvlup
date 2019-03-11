<aura:application extends="force:slds">
    <div class="slds-tabs--scoped slds-size--1-of-6">
        <ul class="slds-tabs--scoped__nav" role="tablist">
            <li aura:id="jhonTab" class="slds-tabs--scoped__item slds-active" title="Item One" role="presentation">
                <a class="slds-tabs--scoped__link" role="tab" tabindex="0" id="tab-scoped-1__item" onclick="{!c.selectJohn}">
                    Jhon
                </a>
            </li>
            <li aura:id="janeTab" class="slds-tabs--scoped__item" title="Item Two" role="presentation">
                <a class="slds-tabs--scoped__link" role="tab" tabindex="1" id="tab-scoped-2__item" onclick="{!c.selectJane}">
                    Jane
                </a>
            </li>
        </ul>
        <div aura:id="tab-scoped-1" class="slds-tabs--scoped__content slds-show" role="tabpanel">
            <c:LtngFacet > 
                <aura:set attribute="name"> John Doe </aura:set>
                <aura:set attribute="empId"> 02417 </aura:set>
                <aura:set attribute="photo">
                    <img src="/resource/SLDS/assets/images/avatar1.jpg" alt="Employee Image" />
                </aura:set>
            </c:LtngFacet>
        </div>
        <div aura:id="tab-scoped-2" class="slds-tabs--scoped__content slds-hide" role="tabpanel">
            <c:LtngFacet > 
                <aura:set attribute="name"> Jane Doe </aura:set>
                <aura:set attribute="empId"> 02418 </aura:set>
                <aura:set attribute="photo">
                    <img src="/resource/SLDS/assets/images/avatar2.jpg" alt="Employee Image" />
                </aura:set>
            </c:LtngFacet>
        </div>
    </div>
</aura:application>