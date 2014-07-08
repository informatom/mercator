Contracting.ConsumableitemRoute = Ember.Route.extend
  model: (params) ->
    @store.find "consumableitem", params.consumableitem_id