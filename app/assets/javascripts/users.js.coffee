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
  $('.user-avatar').attr('src', "#{file.url}/convert?height=120")