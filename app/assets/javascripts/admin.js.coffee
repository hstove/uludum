# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$('[data-model]').click (e) ->
  $el = $(e.target)
  name = $el.data('model')
  $("[data-name='#{name}']").toggle()
  $el.toggleClass('icon-chevron-up').toggleClass('icon-chevron-down')
  false