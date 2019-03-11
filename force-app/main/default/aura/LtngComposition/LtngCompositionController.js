({
    selectJohn: function(cmp, event) {
        var jhonTab = cmp.find('jhonTab');
        var jhonBody = cmp.find('tab-scoped-1');
        var janeTab = cmp.find('janeTab');
        var janeBody = cmp.find('tab-scoped-2');
        $A.util.addClass(jhonTab, 'slds-active');
        $A.util.removeClass(janeTab, 'slds-active');
        $A.util.addClass(jhonBody, 'slds-show');
        $A.util.removeClass(janeBody, 'slds-show');
        $A.util.addClass(janeBody, 'slds-hide');
        $A.util.removeClass(jhonBody, 'slds-hide');
        
    },
    
    selectJane: function(cmp, event) {
        var jhonTab = cmp.find('jhonTab');
        var jhonBody = cmp.find('tab-scoped-1');
        var janeTab = cmp.find('janeTab');
        var janeBody = cmp.find('tab-scoped-2');
        $A.util.addClass(janeTab, 'slds-active');
        $A.util.removeClass(jhonTab, 'slds-active');
        $A.util.addClass(janeBody, 'slds-show');
        $A.util.removeClass(jhonBody, 'slds-show');
        $A.util.addClass(jhonBody, 'slds-hide');
        $A.util.removeClass(janeBody, 'slds-hide');
    }
})