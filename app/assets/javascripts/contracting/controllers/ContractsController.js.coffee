Contracting.ContractsController = Ember.ArrayController.extend
  sortProperties: ['id'],
  sortAscending: true,

  actions:
    create: ->
      contract = @store.createRecord("contract",
        startdate: moment().toDate()
      )
      contract.save()