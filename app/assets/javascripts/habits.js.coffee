# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

m =
  "January"    : 0,
  "February"   : 1,
  "March"      : 2,
  "April"      : 3,
  "May"        : 4,
  "June"       : 5,
  "July"       : 6,
  "August"     : 7,
  "September"  : 8,
  "October"    : 9,
  "November"   : 10,
  "December"   : 11

decimalToHex = (i) ->
  return '00000' + i.toString 16 if i >= 0 and i <= 15
  return '0000' + i.toString 16 if i >= 16 and i <= 255
  return '000' + i.toString 16 if i >= 256 and i <= 4095
  return '00' + i.toString 16 if i >= 4096 and i <= 65535
  return i.toString(16)

$ ->

  $.get '/chains',
    (data) ->
      for chain in data
        chainDate = new Date(chain.day.toString()).toDateString().replace(/[ ]/gi, '-')
        dow = $('#' + chainDate).text()
        if $('#' + chainDate).text().indexOf('X') == -1
          $('#' + chainDate).text(dow + ' X')


  $('.add-habit').tooltip()

  $('.add-habit').click ->
      current_id = $('#habit-id').val()
      if current_id == $(this).attr('id')
        $('#habit-id').val ''
        $('.lead').css 'font-weight', '200'
      else
        $('#habit-id').val $(this).attr('id')
        $('.lead').css 'font-weight', '200'
        $(this).css 'font-weight', 'bold'

  $('#calendar td').live 'click', ->
    habitID = $('#habit-id').val()
    day = new Date($('h1.year').text(), m[$('h3.month').text()], $(this).data('dow'))
    $('#habit-list').html('')
    $.get '/chains?day=' + day, 
      (data) ->
        for chain in data
          $('#habit-list').append('<li style="color: #' + decimalToHex(chain.habit.color) + '"><span class="lead">X ' + chain.habit.content + '<span></li>')
    if habitID != null and habitID != ''
      $.post('/chains',
        'chain[habit_id]': habitID
        'chain[user_id]': 0
        'chain[day]': day,
        (data) =>
          if $(this).text().indexOf('X') == -1
            $(this).text($(this).text() + ' X')
          if data
            $('#habit-list').append('<li style="color: #' + decimalToHex(data.habit.color) + '"><span class="lead">X ' + data.habit.content + '<span></li>')
        ).error (data) ->
          response = JSON.parse data.responseText
          responseString = ""

          for k,v of response
            responseString += v + '\n'
          $('p.alert-error').css('display', 'block').text(responseString)

