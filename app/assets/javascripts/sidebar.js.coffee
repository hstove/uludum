$ ->
  #sidebar toggle show
  $('i[data-class]').click (e) ->
    $el = $(e.target)
    class_name = $el.attr 'data-class'
    $others = $(".sidebar-inactive[data-class='#{class_name}']")
    if $el.hasClass 'icon-chevron-up'
      #show others
      $others.slideDown()
      $el.addClass('icon-chevron-down').removeClass('icon-chevron-up')
    else
      $others.slideUp()
      $el.addClass('icon-chevron-up').removeClass('icon-chevron-down')
    false

  $('.toggle-sidebar').click ->
    if ($content = $('.content')).hasClass('span12')
      $content.addClass('span9').removeClass('span12')
      $('#sidebar').show()
      $('.toggle-sidebar .fa').attr('class', 'fa fa-angle-double-left')
      $('.toggle-sidebar').css('left', 255)
    else
      $content.addClass('span12').removeClass('span9')
      $('#sidebar').hide()
      $('.toggle-sidebar .fa').attr('class', 'fa fa-angle-double-right')
      $('.toggle-sidebar').css('left', 0)
