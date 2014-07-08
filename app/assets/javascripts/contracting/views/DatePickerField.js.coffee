Contracting.DatePickerField = Em.View.extend
  templateName: "datepicker"

  valueAsDate: (->
    moment(@get("value")).format "DD.MM.YYYY"
  ).property("view.value")

  didInsertElement: ->
    self = this

    onChangeDate = (ev) ->
      self.set "value", moment(ev.date).add('hours', 2).toDate()

    @$(".datepicker").datepicker
      separator: "."
    .on "changeDate", onChangeDate