Contracting.ContractItemsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('contract').get 'contractItems'