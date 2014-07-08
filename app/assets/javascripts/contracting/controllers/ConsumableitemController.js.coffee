Contracting.ConsumableitemController = Ember.ObjectController.extend
  actions:
    delete: ->
      consumableitem = @get("model")
      contractitem = consumableitem.get("contractitem")
      contractitem.then (contractitem) ->
        contractitem.get("consumableitems").removeObject consumableitem

      consumableitem.destroyRecord()
      @transitionToRoute "contractitem", contractitem

    save: ->
      @wantstodelete = true
      consumableitem = @get("model")
      consumableitem.save()
      return

    wantstodelete: false

    toggle: (attribute) ->
      @toggleProperty attribute
      return