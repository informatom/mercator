Ember.Handlebars.helper "formatDatetime", (value, options) ->
  moment.lang "de"
  formatted_date = moment(value).format("DD.MM.YYYY, HH:mm")
  new Ember.Handlebars.SafeString(formatted_date)
