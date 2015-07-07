Contracting.ContractsRoute = Ember.Route.extend
  model: (params) ->
    @store.find "contract"