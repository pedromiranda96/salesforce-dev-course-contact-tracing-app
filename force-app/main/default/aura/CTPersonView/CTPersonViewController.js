({
	personSelectHandler : function(component, event, helper) {
		component.set('v.recordId', event.getParam('recordId'));
		component.set('v.recordId', event.getParam('status'));
	},

	updateStatus: function(component, event, helper) {
		helper.updateStatus(component);
	}
})
