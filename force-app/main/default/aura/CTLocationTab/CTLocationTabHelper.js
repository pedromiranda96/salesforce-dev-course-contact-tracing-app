({
	getLocationInformation : function(component) {
		const recordId = component.get("v.recordId");
		
		const action = component.get("c.getLocationDetails");
		action.setParams({
			recordId,
		});
		
		action.setCallback(this, function(response) {
			const state = response.getState();
			if(state === 'SUCCESS') {
				const data = response.getReturnValue();
				if(!data) {
					this.showToast("ERROR", "Location not found", "error");
				} else {
					component.set("v.location", data);
				}
				
				component.set("v.locationFound", !!data);
			}
		});

		$A.enqueueAction(action);
	},

	showToast: function(title, message, type) {
		const toastEvent = $A.get('e.force:showToast');
		toastEvent.setParams({
			title,
			message,
			type,
		});

		toastEvent.fire();
	}
})
