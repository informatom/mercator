delete: ->
  contractitem = @get("model")
  contract = contractitem.get("contract")
  contractitem.get("consumableitems").forEach (consumableitem) ->
    consumableitem.destroyRecord()

  contract.then (contract) ->
    contract.get("contractitems").removeObject contractitem

  contractitem.destroyRecord()
  @transitionToRoute "contract", contract

createConsumable: ->
  contractitem = @get("model")

  if isFinite(contractitem.get("maxposition"))
    position = contractitem.get("maxposition") + 10
  else
    position = 10

  consumableitem = @store.createRecord("consumableitem",
    position: position
    contractitem: @get("model")
  )
