Contracting.Contractitem = DS.Model.extend
  contract: DS.belongsTo("contract",
    async: true
  )
  consumableitems: DS.hasMany("consumableitem",
    async: true
  )

  position: DS.attr("number")
  term: DS.attr("number")
  startdate: DS.attr("date")
  productNumber: DS.attr("string")
  descriptionDe: DS.attr("string")
  descriptionEn: DS.attr("string")
  amount: DS.attr("number")
  unit: DS.attr("string")
  volumeBw: DS.attr("number")
  volumeColor: DS.attr("number")
  marge: DS.attr("number")
  vat: DS.attr("number")
  discountAbs: DS.attr("number")
  monitoringRate: DS.attr("number")
  createdAt: DS.attr("date")
  updatedAt: DS.attr("date")

  price: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("value")
  ).property("consumableitems.@each.value")

  enddate: (->
    moment(@get("startdate")).add("months", @get("term")).subtract "days", 1
  ).property("startdate", "term")

  monthlyRate: (->
    @get("price") / @get("term")
  ).property("price", "term")

  value: (->
    @get("monthlyRate") + parseFloat(@get("monitoringRate")) - @get("discountAbs")
  ).property("monthlyRate", "monitoringRate", "discountAbs")

  valueInclVat: (->
    @get("value") * (100 + parseFloat(@get("vat"))) / 100
  ).property("value", "vat")

  newRate2: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("newRate2")
  ).property("consumableitems.@each.newRate2")

  newRateWithMonitoring2: (->
    @get("newRate2") + parseFloat(@get("monitoringRate"))
  ).property("newRate2", "monitoringRate")

  newRate3: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("newRate3")
  ).property("consumableitems.@each.newRate3")

  newRateWithMonitoring3: (->
    @get("newRate3") + parseFloat(@get("monitoringRate"))
  ).property("newRate3", "monitoringRate")

  newRate4: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("newRate4")
  ).property("consumableitems.@each.newRate4")

  newRateWithMonitoring4: (->
    @get("newRate4") + parseFloat(@get("monitoringRate"))
  ).property("newRate4", "monitoringRate")

  newRate5: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("newRate5")
  ).property("consumableitems.@each.newRate5")

  newRateWithMonitoring5: (->
    @get("newRate5") + parseFloat(@get("monitoringRate"))
  ).property("newRate5", "monitoringRate")

  newRate6: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("newRate6")
  ).property("consumableitems.@each.newRate6")

  newRateWithMonitoring6: (->
    @get("newRate6") + parseFloat(@get("monitoringRate"))
  ).property("newRate6", "monitoringRate")

  balance1: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("balance1")
  ).property("consumableitems.@each.balance1", "monitoringRate")

  balance2: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("balance2")
  ).property("consumableitems.@each.balance2", "monitoringRate")

  balance3: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("balance3")
  ).property("consumableitems.@each.balance3", "monitoringRate")

  balance4: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("balance4")
  ).property("consumableitems.@each.balance4", "monitoringRate")

  balance5: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("balance5")
  ).property("consumableitems.@each.balance5", "monitoringRate")

  balance6: (->
    @get("consumableitems").reduce (prevVal, item) ->
      (prevVal or 0) + item.get("balance6")
  ).property("consumableitems.@each.balance6", "monitoringRate")

  monthsWithoutRates1: (->
    if @get("balance1") < 0
      Math.floor(@get("balance1") / @get("newRate1")) * (-1)
    else
      0
  ).property("newRate1", "balance1")

  monthsWithoutRates2: (->
    if @get("balance2") < 0
      Math.floor(@get("balance2") / @get("newRate2")) * (-1)
    else
      0
  ).property("newRate2", "balance2")

  monthsWithoutRates3: (->
    if @get("balance3") < 0
      Math.floor(@get("balance3") / @get("newRate3")) * (-1)
    else
      0
  ).property("newRate3", "balance3")

  monthsWithoutRates4: (->
    if @get("balance4") < 0
      Math.floor(@get("balance4") / @get("newRate4")) * (-1)
    else
      0
  ).property("newRate4", "balance4")

  monthsWithoutRates5: (->
    if @get("balance5") < 0
      Math.floor(@get("balance5") / @get("newRate5")) * (-1)
    else
      0
  ).property("newRate5", "balance5")

  nextMonth1: (->
    ((@get("monthsWithoutRates1") * @get("newRate2")) + parseFloat(@get("balance1"))) * (-1)
  ).property("monthsWithoutRates1", "newRate2", "balance1")

  nextMonth2: (->
    ((@get("monthsWithoutRates2") * @get("newRate3")) + parseFloat(@get("balance2"))) * (-1)
  ).property("monthsWithoutRates2", "newRate3", "balance2")

  nextMonth3: (->
    ((@get("monthsWithoutRates3") * @get("newRate4")) + parseFloat(@get("balance3"))) * (-1)
  ).property("monthsWithoutRates3", "newRate4", "balance3")

  nextMonth4: (->
    ((@get("monthsWithoutRates4") * @get("newRate5")) + parseFloat(@get("balance4"))) * (-1)
  ).property("monthsWithoutRates4", "newRate5", "balance4")

  nextMonth5: (->
    ((@get("monthsWithoutRates5") * @get("newRate6")) + parseFloat(@get("balance5"))) * (-1)
  ).property("monthsWithoutRates5", "newRate6", "balance5")

  positions: Ember.computed.mapBy('consumableitems', 'position'),
  maxposition: Ember.computed.max('positions')