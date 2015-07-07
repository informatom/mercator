Contracting.IndexRoute = Ember.Route.extend
  beforeModel: (params) ->
    @transitionTo "contracts"