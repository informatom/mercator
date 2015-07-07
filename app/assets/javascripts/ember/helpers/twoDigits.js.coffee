Ember.Handlebars.helper "twoDigits", (value, options) ->
  moment.lang "de"
  formatted_currency = parseFloat(value, 10).toFixed(2)
  new Ember.Handlebars.SafeString(formatted_currency)
  