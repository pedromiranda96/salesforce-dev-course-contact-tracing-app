({
	doInit: function(component, event, helper) {
		helper.generateColumns(component);
		helper.getRecentHealthChanges(component);
	},

	handleKeyUp: function(component, event, helper) {
		const query = component.find('search').get('v.value');
		if(!query) {
			component.set('v.data', component.get('v.initialData'));
			return;
		}

		if(event.keyCode === 13) {
			component.set('v.isSearching', true);
			helper.searchRecords(component, query);
		}
	},

	handleRowAction: function(component, event, helper) {
		const action = event.getParam('action');
		const row = event.getParam('row');
		const scope = component.get('v.scope');

		switch(action.name) {
			case 'view_details': {
				const applicationEvent = scope === 'person'
					? $A.get("e.c:CTPersonSelectEvent")
					: $A.get("e.c:CTLocationSelectEvent");

				applicationEvent.setParams({
					recordId: row.Id,
					status: scope === 'person' ? row.Health_Status__c : row.Status__c,
				});

				applicationEvent.fire();
				break;
			}
		}
	}
})
