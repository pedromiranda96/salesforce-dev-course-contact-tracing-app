({
	getUserInformation : function(component) {
		const recordId = component.get("v.recordId");
		
		const action = component.get("c.getUserDetails");
		action.setParams({
			recordId,
		});
		
		action.setCallback(this, function(response) {
			const state = response.getState();
			if(state === 'SUCCESS') {
				const data = response.getReturnValue();
				if(!data) {
					this.showToast("ERROR", "User not found", "error");
				} else {
					component.set("v.user", data);
				}
				
				component.set("v.userFound", !!data);
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
