@pickAvatar = (event) ->
  file = event.fpfile
  title = "Successfully selected "
  if file.filename
    title += file.filename
  else
    title += "file"
  title += "."
  $parent = $(event.currentTarget).parents('.field')
  $parent.find('.image-success').text(title)
  if file.url
    $parent.find('.image-preview img').attr('src', "#{file.url}/convert?h=120").parent().show()
    $parent.find('input[type="filepicker"]').attr('value',file.url)