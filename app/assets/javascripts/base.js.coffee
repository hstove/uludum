$(document).ready ->
  $('[data-toggle="tooltip"]').tooltip()
  $progress = $('.progress')
  $bar = $('.progress .bar')
  newWidth = $bar.attr('progress')
  oldWidth = $bar.attr('old_progress')
  animateProgress = -> 
    $bar.css('width', "#{newWidth}%")
    endStripes = -> $progress.removeClass('progress-striped').removeClass('active')
    setTimeout(endStripes, 1000)
  $progress.addClass('progress-striped').addClass('active') unless newWidth == oldWidth
  setTimeout(animateProgress, 2000)
  