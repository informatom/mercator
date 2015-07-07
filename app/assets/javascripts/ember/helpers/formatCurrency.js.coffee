Ember.Handlebars.helper "formatCurrency", (value, options) ->
  moment.lang "de"
  formatted_currency = parseFloat(value, 10).toFixed(2) + " EUR"
  new Ember.Handlebars.SafeString(formatted_currency)