Contracting.Contract = DS.Model.extend
  contractItems: DS.hasMany("contractItem",
    async: true
  )

  term: DS.attr("number")
  startdate: DS.attr("date")
  createdAt: DS.attr("date")
  updatedAt: DS.attr("date")

  enddate: (->
    moment(@get("startdate")).add("months", @get("term"))
                             .subtract "days", 1
  ).property("startdate", "term")

  positions: Ember.computed.mapBy('contractItems', 'position'),
  maxposition: Ember.computed.max('positions')
