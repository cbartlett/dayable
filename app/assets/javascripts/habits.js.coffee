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

parsePgDate = (db_date) ->
  return new Date(db_date.split('-')[0], db_date.split('-')[1]-1, db_date.split('-')[2]).toDateString().replace(/[ ]/gi, '-')

$ ->

  _.templateSettings = 
    interpolate : /\{\{(.+?)\}\}/g

  newHabitTemplate = _.template '<li><input id="habit-content" name="habit[content]" type="text"></input></li>'
  editHabitTemplate = _.template '<input class="habit-edit-content" data-id="{{id}}" name="habit[content]" type="text" value="{{content}}"></input>'
  habitTemplate = _.template '<div class="reverse-well">
    <a href="javascript://" class="lead add-habit" data-id="{{id}}" rel="tooltip" data-original-title="Click this then click a date to add a habit.">{{content}}</a>
    <a href="javascript://" class="edit-habit" data-id="{{id}}"><i class="icon-pencil"></i></a>
    <a href="javascript://" class="delete-habit" data-id="{{id}}"><i class="icon-trash"></i></a>
    </div>'

  handleError = (data) ->
    response = JSON.parse data.responseText
    responseString = ""

    for k,v of response
      responseString += v + '\n'

    if data.status == 406
      $('.alert-info').html(responseString + '<a class="close">&times;</a>').fadeIn()
    else
      $('.alert-error').html(responseString + '<a class="close">&times;</a>').fadeIn()

  clearCalendarData = ->
    $('.chain').remove()

  fillInCalendarData = (habitID) ->
    # clear the calendar first
    clearCalendarData()

    $.get '/chains?habit_id=' + habitID,
      (data) ->
        for chain in data
          chainDate = parsePgDate chain.day
          dow = $('#' + chainDate).text()
          $('#' + chainDate).attr('data-id', chain.id)
          if $('#' + chainDate + ' .cal-data').has('.chain')
            $('#' + chainDate + ' .cal-data').append('<span class="chain">&times;</span>')


  $('#new-habit').click ->
    if $('#habit-content').length == 0
      # show textbox
      $('#habit-list').append newHabitTemplate
      $('#habit-list li:last #habit-content').focus()

  $('#habit-content').live 'keypress', (e) ->
    if e.keyCode == 13
      $.post('/habits',
        'habit[content]': $(this).val(),
        (data) =>
          $('#habit-list li:last').remove()
          $('#habit-list').append "<li>" + (habitTemplate data) + "</li>"
        )

  $('.edit-habit').live 'click', ->
    habitElement = $(this).parent().find('a:first')
    $(this).closest('li').html editHabitTemplate { content: habitElement.text(), id: habitElement.data('id') }

  $('.habit-edit-content').live 'keypress', (e) ->
    if e.keyCode == 13
      $.ajax
        type: 'PUT',
        url: '/habits/' + $(this).data('id') + '.json',
        data:
          'habit[content]' : $(this).val(),
        success: (data) =>
          $(this).parent().html habitTemplate { content: $(this).val(), id: $(this).data('id') }
        error: handleError(data)

  $('.delete-habit').live 'click', ->
    if confirm 'Are you sure you want to get rid of this habit?'
      $.ajax
        type: 'DELETE'
        url: '/habits/' + $(this).data('id')
        data:
          'habit[content]': $(this).val()
        success: (data) =>
          $(this).closest('li').remove()
        error: handleError(data)

  $('.add-habit').live 'click',  ->
      current_id = $('#habit-id').val()
      if parseInt(current_id, 10) == parseInt($(this).data('id'), 10)
        $('#habit-id').val ''
        $('.add-habit').parent().css 'background-color', '#EFEFEF'
        clearCalendarData()
      else
        $('#habit-id').val $(this).data('id')
        $('.add-habit').parent().css 'background-color', '#EFEFEF'
        $(this).parent().css 'background-color', '#BBD8E9'
        fillInCalendarData $(this).data('id')

  $('#next, #last, #current').live 'click', ->
    habitID = $('#habit-id').val()
    if habitID
      fillInCalendarData habitID

  $('.close').live 'click', ->
    $(this).parent().fadeOut()

  $('#calendar td').live 'click', ->
    habitID = $('#habit-id').val()
    day = new Date($('h1.year').text(), m[$('h3.month').text()], $(this).data('dow'))
    chainDate = day.toDateString().replace(/[ ]/gi, '-')
    if habitID
      if $('#' + chainDate + ' .cal-data').children().length == 0
        $.post('/chains',
          'chain[habit_id]': habitID
          'chain[user_id]': 0
          'chain[day]': day,
          (chain) =>
            $('#' + chainDate + ' .cal-data').append('<span class="chain">&times;</span>')
            $('#' + chainDate).attr('data-id', chain.id)
          ).error (data) ->
            handleError(data)
      else
        if $(this).attr('data-id')
          $.post('/chains/' + $(this).attr('data-id'), 
            { _method: 'delete' }, 
            (chain) =>
              chainDate = day.toDateString().replace(/[ ]/gi, '-')
              $('#' + chainDate + ' .chain').remove()
              $('#' + chainDate).attr('data-id', '')
            ).error (data) ->
              handleError(data)
