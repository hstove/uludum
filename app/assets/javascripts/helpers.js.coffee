utensil = """
  <li>
    <div class="btn-group">
      <a class="btn" data-toggle="dropdown" data-placement="top">Embed Special Objects</a>
        <ul class="dropdown-menu utensil-dropdown" role="menu">
        </ul>
    </div>
  </li>
  """

isElementInViewport = (el) ->
  rect = el.getBoundingClientRect()
  #or $(window).height()
  rect.top >= 0 and
  rect.left >= 0 and
  rect.bottom <= (window.innerHeight or document.documentElement.clientHeight) and
  rect.right <= (window.innerWidth or document.documentElement.clientWidth)

$(document).ready ->
  resizeIframe = ->
    currentHeight = editor.composer.iframe.style.height
    unless (scrollHeight = editor.composer.element.scrollHeight) < currentHeight
      editor.composer.iframe.style.height = editor.composer.element.scrollHeight + "px"

  $('.wysihtml5').each (i, el) ->
    $el = $(el)
    name = $el.attr('name')
    val = $el.val()
    $("<input name=#{name} type='hidden'>").insertAfter($el).val(val)
    $el.val toMarkdown(val)
    $el.markdown
      iconlibrary: 'fa'

  $('.wysihtml5-toolbar').append(utensil)
  _.each Utensil.utensils, (u) ->
    $('.utensil-dropdown').append("<li><a href='#' class=\"pick-utensil\">#{u.name}</a></li>")
  Utensil.renderUtensils()
  $('.pick-utensil').click (e) ->
    mixpanel.track("using utensil");
    $el = $(e.target)
    $textarea = $el.attr 'data-element'
    id = $el.parent().parent().parent().parent().parent().siblings('textarea').attr('id')
    Utensil.currentTextarea = $("##{id}")
    name = $el.text()
    utensil = Utensil.find(name)
    if utensil
      $("#utensils").html(utensil.formTemplate)
      $form = $(".utensil-form")
      $form.attr('data-utensil', name)
      $form.attr 'action', utensil.action
      $('.modal-utensil-title').text utensil.name
      $('#utensil-modal').modal()
      utensil.onFormLoad($form)
      $form.one "submit", (e) ->
        output = $.extend({type: utensil.name}, utensil.processForm($form))
        Utensil.appendHtml(output)
        false
    else
      console.log "no utensil found for #{name}"
    false
    # Utensil.renderUtensils()

  _.each $('utensil'), (el) ->
    $el = $(el)
    json = JSON.parse($el.text())
    console.log json
    utensil = Utensil.find(json.type)
    $(utensil.fromOpts(json)).insertBefore($el)
    $el.remove()
  $('[data-toggle="tooltip"]').tooltip()
  animateProgress = ($progress, newWidth) ->
    $bar = $progress.find('.bar')
    newWidth += "%"
    $bar.css('width', newWidth)
    $progress.find('span').html newWidth
    endStripes = -> $progress.removeClass('progress-striped').removeClass('active')
    setTimeout(endStripes, 1000)
  _.each $('.progress'), (el) ->
    $progress = $(el)
    $bar = $progress.find('.bar')
    newWidth = $bar.attr('progress')
    oldWidth = $bar.attr('old_progress')
    $progress.addClass('progress-striped').addClass('active') unless newWidth == oldWidth
    setTimeout(animateProgress, 2000, $progress, newWidth)



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

  #class outline toggle subsections
  $('i[data-section]').click (e)->
    $el = $(e.target)
    $el.toggleClass('icon-chevron-up').toggleClass('icon-chevron-down')
    section = $el.data('section')
    $("tr[data-section='#{section}']").toggle()
    false

  # $('.dynamo').dynamo()

  el = $('.intro-step')[0]
  if el
    delay = 500
    handler = ->
      if isElementInViewport(el)
        for step,i in $('.intro-step')
          setTimeout ((_step)->
            ->
              $(_step).addClass('viewed')
          )(step), delay*i
        $(window).off 'DOMContentLoaded load resize scroll', handler
        setTimeout ->
          $btn = $('.intro-steps .btn-primary')
          $btn.css('transition', 'all 1s')
          $btn.addClass('btn-success').removeClass('btn-primary')
          $btn.css('box-shadow', '0 0 0 0 black').css('box-shadow','0 0 15px 0 #525252')
        , ($('.intro-step').length+1) * delay
    $(window).on 'DOMContentLoaded load resize scroll', handler
