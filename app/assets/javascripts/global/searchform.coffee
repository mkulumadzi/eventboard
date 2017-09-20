$(document).on "click", "#todayButton", (event) ->
  $('#customDateFormGroup').hide()
  $('#time').get(0).value = "today"

$(document).on "click", "#tomorrowButton", (event) ->
  $('#customDateFormGroup').hide()
  $('#time').get(0).value = "tomorrow"

$(document).on "click", "#thisWeekendButton", (event) ->
  $('#customDateFormGroup').hide()
  $('#time').get(0).value = "thisWeekend"

$(document).on "click", "#customDateButton", (event) ->
  $('#customDateFormGroup').show()
