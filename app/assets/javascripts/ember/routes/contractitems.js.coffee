Contracting.ContractitemsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('contract').get 'contractitems'