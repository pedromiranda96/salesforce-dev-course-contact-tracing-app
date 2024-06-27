({
	generateColumns: function(component) {
		const scope = component.get('v.scope');

		if(scope === 'person') {
			component.set('v.columns', [
				{ label: 'Name', fieldName: 'Name', type: 'text' },
				{ label: 'Phone', fieldName: 'Mobile__c', type: 'text' },
				{ label: 'Token', fieldName: 'Token__c', type: 'text' },
				{ label: 'Health Status', fieldName: 'Health_Status__c', type: 'text' },
				{ label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date' },
				{
					label: 'View',
					type: 'button',
					initialWidth: 135,
					typeAttributes: {
						label: 'View/Update',
						name: 'view_details',
						title: 'Click to view details',
					},
				}
			]);
		} else {
			component.set('v.columns', [
				{ label: 'Name', fieldName: 'Name', type: 'text' },
				{ label: 'Status', fieldName: 'Status__c', type: 'text' },
				{ label: 'Red Score', fieldName: 'Red_Score__c', type: 'number' },
				{ label: 'Pincode', fieldName: 'Pincode__c', type: 'text' },
				{ label: 'Address', fieldName: 'Address__c', type: 'text' },
				{ label: 'Status Update Date', fieldName: 'Status_Update_Date__c', type: 'date' },
				{
					label: 'View',
					type: 'button',
					initialWidth: 135,
					typeAttributes: {
						label: 'View/Update',
						name: 'view_details',
						title: 'Click to view details',
					},
				}
			]);
		}
	},

	getRecentHealthChanges: function(component) {
		const scope = component.get('v.scope');
		const action = scope === 'person'
			? component.get('c.getRecentPersonHealthChanges')
			: component.get('c.getRecentLocationHealthChanges');

		action.setCallback(this, function (response) {
			const state = response.getState();
			if(state === 'SUCCESS') {
				const data =  response.getReturnValue();
				component.set('v.initialData', data);
				component.set('v.data', data);
			}
		});

		$A.enqueueAction(action);
	},

	searchRecords: function(component, query) {
		const scope = component.get('v.scope');
		const action = scope === 'person'
			? component.get('c.searchPeople')
			: component.get('c.searchLocations');

		action.setParams({
			searchTerm: query,
		});

		action.setCallback(this, function (response) {
			const state = response.getState();
			if(state === 'SUCCESS') {
				const data =  response.getReturnValue();
				if(data && data.length) {
					component.set('v.data', data);
				}

				component.set('v.isLoading', false);
			}
		});

		$A.enqueueAction(action);
	}
})
