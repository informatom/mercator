Contracting.ContractItemController = Ember.ObjectController.extend
  actions:
    delete: ->
      contractItem = @get("model")
      contract = contractItem.get("contract")
      contractItem.get("consumableItems").forEach (consumableItem) ->
        consumableItem.destroyRecord()

      contract.then (contract) ->
        contract.get("contractItems").removeObject contractItem

      contractItem.destroyRecord()
      @transitionToRoute "contract", contract

    createConsumable: ->
      contractItem = @get("model")

      if isFinite(contractItem.get("maxposition"))
        position = contractItem.get("maxposition") + 10
      else
        position = 10

      consumableItem = @store.createRecord("consumableItem",
        position: position
        contractItem: @get("model")
      )

      consumableItem.save().then (consumableItem) ->
        contractItem.get("consumableItems").pushObject consumableItem

    save: ->
      @wantstodelete = true
      contractItem = @get("model")
      contractItem.save()
      return

    wantstodelete: false

    toggle: (attribute) ->
      @toggleProperty attribute
      return