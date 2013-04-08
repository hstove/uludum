utensil = """
  <li>
    <div class="btn-group">
      <a class="btn pick-utensil" data-toggle="tooltip" data-placement="top" title="Embed special objects"><i class="icon-star"></i></a>
    </div>
  </li>
  """

$(document).ready ->
  $('.wysihtml5').each (i, el) ->
    tagOpts = 
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
      utensil: {
        allow_attributes: ['data-body','style']
      }
      a:
        set_attributes:
          target: "_blank"
          rel: "nofollow"
        check_attributes:
          href: "url" # important to avoid XSS
    $(el).wysihtml5
      cleanUp: false
      stylesheets: ["/assets/utensil.css"]
      image: false
      tags: tagOpts
      parserRules: 
        tags: tagOpts
        
  $('.wysihtml5-toolbar').append(utensil)
  Utensil.renderUtensils()
  $('.pick-utensil').click (e) ->
    $el = $(e.target)
    $textarea = $el.attr 'data-element'
    $('#utensil-modal').modal()
    if $el.hasClass('pick-utensil')
      id = $el.parent().parent().parent().siblings('textarea').attr('id')
    else
      #they clicked the icon
      id = $el.parent().parent().parent().parent().siblings('textarea').attr('id')
    Utensil.currentTextarea = $("##{id}")
    Utensil.renderUtensils()

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




