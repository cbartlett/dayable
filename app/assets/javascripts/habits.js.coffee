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

  # feature tour
  if $('#sign_out').length == 0
    $(this).featureTour()

  _.templateSettings = 
    interpolate : /\{\{(.+?)\}\}/g

  newHabitTemplate = _.template $('#newHabitTemplate').html()
  editHabitTemplate = _.template $('#editHabitTemplate').html()
  habitTemplate = _.template $('#habitTemplate').html()

  handleError = (data) ->
    if not data
      return
    response = JSON.parse data.responseText
    responseString = ""

    for k,v of response
      responseString += v + '\n'

    if data.status == 406
      $('.alert-info').html(responseString + '<a class="close">&times;</a>').fadeIn()
    else
      $('.alert-error').html(responseString + '<a class="close">&times;</a>').fadeIn()

  delay = (ms, func) -> setTimeout func, ms

  comboMessage = (linkCount) ->
    if linkCount < 3
      return

    $('.alert-info').html('You\'ve completed this habit ' + linkCount + ' days in a row! Keep it up!' + '<a class="close">&times;</a>').fadeIn()

    delay 5000, -> $('.alert-info').fadeOut()

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
      if $('.tour-tip-next').data('touridx') == 1
        $('.tour-tip-next').trigger('click')
      $('#habit-list').append newHabitTemplate
      $('#habit-list li:last #habit-content').focus()

  $('#habit-content').live 'keypress', (e) ->
    if e.keyCode == 13
      $('.alert-info').html('Loading...').fadeIn()
      $.post('/habits',
        'habit[content]': $(this).val(),
        (data) =>
          if $('.tour-tip-next').data('touridx') == 2
            $('.tour-tip-next').trigger('click')
          $('.alert-info').fadeOut('slow')
          $('#habit-list li:last').remove()
          $('#habit-list').append "<li>" + (habitTemplate data) + "</li>"
        )

  $('.save-habit').live 'click', ->
    $('.alert-info').html('Loading...').fadeIn()
    $.post('/habits',
      'habit[content]': $($(this).parent().children()[0]).val(),
      (data) =>
        if $('.tour-tip-next').data('touridx') == 2
            $('.tour-tip-next').trigger('click')
        $('.alert-info').fadeOut('slow')
        $('#habit-list li:last').remove()
        $('#habit-list').append "<li>" + (habitTemplate data) + "</li>"
      )

  $('.cancel-habit').live 'click', ->
    $(this).closest('li').remove()

  $('.edit-habit').live 'click', ->
    habitElement = $(this).parent().find('a:first')
    $(this).closest('li').html editHabitTemplate { content: habitElement.text(), id: habitElement.data('id') }

  $('.habit-edit-content').live 'keypress', (e) ->
    if e.keyCode == 13
      $.ajax
        type: 'PUT'
        url: '/habits/' + $(this).data('id') + '.json'
        data:
          'habit[content]' : $(this).val()
        success: (data) =>
          $(this).parent().html habitTemplate { content: $(this).val(), id: $(this).data('id') }
        error: (data) -> 
          handleError(data)

  $('.delete-habit').live 'click', ->
    if confirm 'Are you sure you want to get rid of this habit?'
      $.ajax
        type: 'DELETE'
        url: '/habits/' + $(this).data('id') + '.json'
        data:
          'habit[content]': $(this).val()
        success: (data) =>
          $(this).closest('li').remove()
        error: (data) -> 
          handleError(data)

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
        if $('.tour-tip-next').data('touridx') == 3
            $('.tour-tip-next').trigger('click')
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
          (data) ->
            if $('.tour-tip-next').data('touridx') == 4
              $('.tour-tip-next').trigger('click')
            comboMessage data.link_count
            $('#' + chainDate + ' .cal-data').append('<span class="chain">&times;</span>')
            $('#' + chainDate).attr('data-id', data.chain.id)
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
