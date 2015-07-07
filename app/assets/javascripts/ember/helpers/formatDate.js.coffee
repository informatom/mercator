Ember.Handlebars.helper "formatDate", (value, options) ->
  moment.lang "de"
  formatted_date = moment(value).format("DD.MM.YYYY")
  new Ember.Handlebars.SafeString(formatted_date)
