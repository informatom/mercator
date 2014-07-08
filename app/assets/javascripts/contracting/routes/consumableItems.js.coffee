Contracting.ConsumableItemsRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('contractItem').get 'consumableItems'
