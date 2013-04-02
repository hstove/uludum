@pickAvatar = (event) ->
  file = event.fpfile
  console.log file
  console.log 'avatar'
  title = "Successfully selected "
  if file.filename
    title += file.filename
  else
    title += "file"
  title += "."
  $('.file-success').text(title)
  if file.url
    $('.user-avatar').attr('src', "#{file.url}/convert?height=120").parent().show()
    $('#user_avatar_url').val(file.url)