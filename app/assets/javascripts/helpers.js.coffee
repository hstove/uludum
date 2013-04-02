utensil = """
  <li>
    <div class="btn-group">
      <a class="btn pick-utensil" data-toggle="tooltip" data-placement="top" title="Embed special objects"><i class="icon-star"></i></a>
    </div>
  </li>
  """

$(document).ready ->
  $('.wysihtml5').each (i, el) ->
    $(el).wysihtml5
      image: false
      tags:
        strong: {}
        b: {}
        i: {}
        em: {}
        br: {}
        p: {}
        div: {}
        span: {}
        ul: {}
        ol: {}
        li: {}
        iframe: {}
        a:
          set_attributes:
            target: "_blank"
            rel: "nofollow"
          check_attributes:
            href: "url" # important to avoid XSS
  $('.wysihtml5-toolbar').append(utensil)
  $('.pick-utensil').click (e) ->
    $el = $(e.target)
    $textarea = $el.attr 'data-element'
    $('#utensil-modal').modal()
    id = $el.parent().parent().parent().siblings('textarea').attr('id')
    window.CUR_TEXTAREA = id
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

  $('i[data-class]').click (e) ->
    $el = $(e.target)
    class_name = $el.attr 'data-class'
    $others = $(".sidebar-inactive[data-class='#{class_name}']")
    if $el.hasClass 'icon-chevron-down'
      #show others
      $others.slideDown()
      $el.addClass('icon-chevron-up').removeClass('icon-chevron-down')
    else
      $others.slideUp()
      $el.addClass('icon-chevron-down').removeClass('icon-chevron-up')
    false
