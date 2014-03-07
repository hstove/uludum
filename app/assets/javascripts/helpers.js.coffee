utensil = """
  <div class="btn-group list-utensils">
  </div>
  """

@markdown =
  toHTML: (str) ->
    marked(str)

isElementInViewport = (el) ->
  rect = el.getBoundingClientRect()
  #or $(window).height()
  rect.top >= 0 and
  rect.left >= 0 and
  rect.bottom <= (window.innerHeight or document.documentElement.clientHeight) and
  rect.right <= (window.innerWidth or document.documentElement.clientWidth)

renderUtensil = (el) ->
  $el = $(el)
  json = JSON.parse($el.text())
  utensil = Utensil.find(json.type)
  $(utensil.fromOpts(json)).insertBefore($el)
  $el.remove()

$(document).ready ->
  resizeIframe = ->
    currentHeight = editor.composer.iframe.style.height
    unless (scrollHeight = editor.composer.element.scrollHeight) < currentHeight
      editor.composer.iframe.style.height = editor.composer.element.scrollHeight + "px"

  $('.wysihtml5').each (i, el) ->
    $el = $(el)
    name = $el.attr('name')
    val = $el.val()
    $field = $("<input name=#{name} type='hidden'>").insertAfter($el).val(val)
    $el.val toMarkdown(val)
    $el.markdown
      iconlibrary: 'fa'
      onKeyup: (e) ->
        newHTML = markdown.toHTML(e.getContent())
        $field.val(newHTML)
      onPreview: (e) ->
        _.each $el.siblings('.md-preview').find('utensil'), renderUtensil


  $('.md-header.btn-toolbar').append(utensil)
  _.each Utensil.utensils, (u) ->
    $('.list-utensils').append(u.render())
  helpMessage = """
  <p class="md-help">
    Content is parsed as
    <a target="_blank" href='https://help.github.com/articles/markdown-basics'
      >Markdown</a>
  </a>
  """
  $('.md-editor').prepend(helpMessage)
  Utensil.renderUtensils()
  $('.pick-utensil').each ->
    $el = $(@)
    $el.tooltip
      title: $el.data('name')
      position: 'top'
  $('.pick-utensil').click (e) ->
    mixpanel?.track("using utensil");
    $el = $(e.currentTarget)
    $textarea = $el.attr 'data-element'
    editor = $el.parents('.md-editor').find('textarea').data('markdown')
    Utensil.currentEditor = editor
    Utensil.selection = editor.getSelection()
    name = $el.data('name')
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

  _.each $('utensil'), renderUtensil
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
