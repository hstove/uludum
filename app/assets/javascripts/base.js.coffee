$(document).ready ->
  $('[data-toggle="tooltip"]').tooltip()
  $progress = $('.progress .bar')
  animateProgress = -> $progress.css('width', "#{$progress.attr('progress')}%")
  setTimeout(animateProgress, 2000)
  