Contracting.ConsumableItemRoute = Ember.Route.extend
  model: (params) ->
    @store.find "consumableItem", params.consumableItem_id