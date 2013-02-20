# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
  $('.add-nested-fields').trigger('mouseup')
  $('#question_multiple_choice').mouseup (e) ->
    if !$(e.target).is(':checked')
      $('.free-answer').hide()
      $('.fields').show()
    else
      $('.free-answer').show()
      $('.fields').hide()