$ ->
  datePickerOptions = {
    autoUpdateInput: false,
    locale: {
        cancelLabel: 'Clear'
    },
    minDate: moment()
  }

  $('input[class="daterange"]').daterangepicker datePickerOptions

  $('input[class="daterange"]').on 'apply.daterangepicker', (ev, picker) ->
    $(this).val(picker.startDate.format('MM/DD/YYYY') + ' - ' + picker.endDate.format('MM/DD/YYYY'))
    $('#time').get(0).value = $(this).val()

  $('input[name="datefilter"]').on 'cancel.daterangepicker', (ev, picker) ->
      $(this).val('')
