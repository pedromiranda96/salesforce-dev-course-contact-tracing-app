({
    doInit: function(component, event, helper) {
        component.set("v.columns", [
            { label: 'Token', fieldName: 'token', type: 'text' },
            { label: 'Contact Status', fieldName: 'status', type: 'text' },
            { label: 'Contact Date', fieldName: 'contactDate', type: 'date' }
        ]);
    },

    handleSearch : function(component, event, helper) {
        helper.getLocationInformation(component);
    }
})
