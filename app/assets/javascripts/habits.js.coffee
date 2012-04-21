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

  $.get '/chains',
    (data) ->
      for chain in data
        chainDate = new Date(chain.day.toString()).toDateString().replace(/[ ]/gi, '-')
        dow = $('#' + chainDate).text()
        if $('#' + chainDate).text().indexOf('X') == -1
          $('#' + chainDate).text(dow + ' X')

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
        error: (data) =>
          console.log data

  $('.delete-habit').live 'click', ->
    if confirm 'Are you sure you want to get rid of this habit?'
      $.ajax
        type: 'DELETE'
        url: '/habits/' + $(this).data('id')
        data:
          'habit[content]': $(this).val()
        success: (data) =>
          $(this).closest('li').remove()
        error: (data) =>
          console.log data
          # handle error

  $('.add-habit').tooltip()

  $('.add-habit').click ->
      current_id = $('#habit-id').val()
      if current_id == $(this).data('id')
        $('#habit-id').val ''
        $('.lead').css 'font-weight', '200'
      else
        $('#habit-id').val $(this).data('id')
        $('.lead').css 'font-weight', '200'
        $(this).css 'font-weight', 'bold'

  $('#calendar td').live 'click', ->
    habitID = $('#habit-id').val()
    day = new Date($('h1.year').text(), m[$('h3.month').text()], $(this).data('dow'))
    $('#chain-list').html('')
    $.get '/chains?day=' + day, 
      (data) ->
        for chain in data
          $('#chain-list').append('<li><span class="lead">X ' + chain.habit.content + '<span></li>')
    if habitID != null and habitID != ''
      $.post('/chains',
        'chain[habit_id]': habitID
        'chain[user_id]': 0
        'chain[day]': day,
        (data) =>
          if $(this).text().indexOf('X') == -1
            $(this).text($(this).text() + ' X')
          if data
            $('#chain-list').append('<li><span class="lead">X ' + data.habit.content + '<span></li>')
        ).error (data) ->
          response = JSON.parse data.responseText
          responseString = ""

          for k,v of response
            responseString += v + '\n'
          $('p.alert-error').css('display', 'block').text(responseString)

