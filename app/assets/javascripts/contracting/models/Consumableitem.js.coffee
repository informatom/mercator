Contracting.Consumableitem = DS.Model.extend(
  contractitem: DS.belongsTo("contractitem",
    async: true
  )

  contractType: DS.attr("string")
  position: DS.attr("number")
  productNumber: DS.attr("string")
  productLine: DS.attr("string")
  descriptionDe: DS.attr("string")
  descriptionEn: DS.attr("string")
  amount: DS.attr("number")
  theyield: DS.attr("number")
  wholesalePrice: DS.attr("number")
  term: DS.attr("number")
  consumption1: DS.attr("number")
  consumption2: DS.attr("number")
  consumption3: DS.attr("number")
  consumption4: DS.attr("number")
  consumption5: DS.attr("number")
  consumption6: DS.attr("number")
  balance6: DS.attr("number")

  price: (->
    @get("wholesalePrice") * (100 + parseFloat(@get("contractitem").get("marge"))) / 100
  ).property("wholesalePrice", "contractitem.marge")

  value: (->
    @get("price") * @get("amount")
  ).property("price", "amount")

  monthlyRate: (->
    @get("value") / @get("term")
  ).property("value", "term")

  newRate2: (->
    if @get("term") is "contractitem.term"
      if @get("amount") * 12 / @get("term") >= 1
        @get("consumption1") * @get("price") / 12
      else
        @get "monthlyRate"
    else
      @get "monthlyRate"
  ).property("term", "contractitem.term", "monthlyRate", "consumption1", "price", "amount")

  newRate3: (->
    if @get("consumption2") > 0
      @get("consumption2") * @get("price")
    else
      "-"
  ).property("consumption2", "price")

  newRate4: (->
    if @get("consumption3") > 0
      @get("consumption3") * @get("price")
    else
      "-"
  ).property("consumption3", "price")

  newRate5: (->
    if @get("consumption4") > 0
      @get("consumption4") * @get("price")
    else
      "-"
  ).property("consumption4", "price")

  newRate6: (->
    if @get("consumption5") > 0
      @get("consumption5") * @get("price")
    else
      "-"
  ).property("consumption5", "price")

  balance1: (->
    (@get("newRate2") - @get("monthlyRate")) * 12
  ).property("newRate2", "monthlyRate")

  balance2: (->
    (@get("newRate3") - @get("newRate2")) * 12
  ).property("newRate3", "newRate2")

  balance3: (->
    (@get("newRate4") - @get("newRate3")) * 12
  ).property("newRate4", "newRate3")

  balance4: (->
    (@get("newRate5") - @get("newRate4")) * 12
  ).property("newRate5", "newRate4")

  balance5: (->
    (@get("newRate6") - @get("newRate5")) * 12
  ).property("newRate6", "newRate5")
)