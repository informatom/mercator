Contracting.ContractController = Ember.ObjectController.extend
  actions:
    createContractItem: ->
      contract = @get("model")

      if isFinite(contract.get("maxposition"))
        position = contract.get("maxposition") + 10
      else
        position = 10

      contractItem = @store.createRecord("contractItem",
        position: position
        contract: @get("model")
        startdate: moment().toDate()
      )

      contractItem.save().then (contractItem) ->
        contract.get("contractItems").pushObject contractItem

    save: ->
      @wantstodelete = true
      contract = @get("model")
      contract.save()
      return

    delete: ->
      contract = @get("model")

      contract.get("contractItems").forEach (contractItem) ->
        contractItem.get("consumableItems").forEach (consumableItem) ->
          consumableItem.destroyRecord()
        contractItem.destroyRecord()
      contract.destroyRecord()
      @transitionToRoute "/"

    wantstodelete: false

    toggle: (attribute) ->
      @toggleProperty attribute
      return