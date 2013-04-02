# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('.pick-utensil').click (e) ->
    $el = $(e.target)
    $textarea = $el.attr 'data-element'
    $('#utensil-modal').show()