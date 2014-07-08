Contracting.ConsumableitemsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('contractitem').get 'consumableitems'
