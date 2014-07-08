Ember.Handlebars.helper "plusYearsMinusDays", (value, options) ->
  moment.lang "de"
  formatted_date = moment(value).add("years", options.hash["years"])
                                .subtract("days", options.hash["days"]).format("DD.MM.YY")
  new Ember.Handlebars.SafeString(formatted_date)
