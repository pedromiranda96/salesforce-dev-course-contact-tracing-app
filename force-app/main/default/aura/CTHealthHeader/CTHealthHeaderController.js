({
	doInit: function(component, event, helper) {
		helper.getStatusCount(component);
	},

	fetchCount: function(component, event, helper) {
		helper.getStatusCount(component);
	},

	createRecord : function(component, event, helper) {
		const scope = component.get('v.scope');

		const createRecordEvent = $A.get('e.force:createRecord');
		createRecordEvent.setParams({
			entityApiName: scope === 'person' ? 'Person__c' : 'Location__c',
		});

		createRecordEvent.fire();
	}
})
