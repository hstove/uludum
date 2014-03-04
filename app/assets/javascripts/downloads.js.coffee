# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('body').on 'change', 'input[type="filepicker"]', (event) ->
    event = event.originalEvent
    file = event.fpfile
    message = "Successfully uploaded #{file.filename}"
    $file = $(event.target)
    $file.siblings('.filepicker-message').text message
    $file.siblings('[name="download[file_name]"]').val file.filename
    $file.siblings('[name="download[file_type]"]').val file.mimetype
