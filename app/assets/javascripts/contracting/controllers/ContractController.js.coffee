Contracting.ContractController = Ember.ObjectController.extend
  actions:
    createContractitem: ->
      contract = @get("model")

      if isFinite(contract.get("maxposition"))
        position = contract.get("maxposition") + 10
      else
        position = 10

      contractitem = @store.createRecord("contractitem",
        position: position
        contract: @get("model")
        startdate: moment().toDate()
        descriptionDe: "Dummy"
        discountAbs: 0
        amount: 1
        vat: 20
      )

      contractitem.save().then (contractitem) ->
        contract.get("contractitems").pushObject contractitem

    save: ->
      @wantstodelete = true
      contract = @get("model")
      contract.save()
      return

    delete: ->
      contract = @get("model")

      contract.get("contractitems").forEach (contractitem) ->
        contractitem.get("consumableitems").forEach (consumableitem) ->
          consumableitem.destroyRecord()
        contractitem.destroyRecord()
      contract.destroyRecord()
      @transitionToRoute "/"

    wantstodelete: false

    toggle: (attribute) ->
      @toggleProperty attribute
      return