Contracting.ContractRoute = Ember.Route.extend
  model: (params) ->
    @store.find "contract", params.contract_id