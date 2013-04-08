# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Utensil
  name: null
  imageUrl: null
  formTemplate: null
  currentTextarea: null
  action: ""
  @utensils: []

  processForm: ($form) ->

  onFormLoad: ->

  constructor: (opts) ->
    $.extend @, opts

  fromOpts: (opts) ->

  @find: (name) ->
    u = null
    _.each Utensil.utensils, (utensil) ->
      u = utensil if utensil.name == name
    u

  @editor: ->
    Utensil.currentTextarea.data().wysihtml5.editor

  @encode: (value) ->
    $('<div/>').text(value).html()

  @decode: (value) ->
    $('<div/>').html(value).text()

  @appendHtml: (options) ->
    html = """
    <utensil>#{JSON.stringify(options, undefined, 2)}</utensil>
    <br>
    """
    Utensil.editor().composer.commands.exec("insertHTML", html)
    $('#utensil-modal').modal 'hide'

  @renderUtensils = ->
    html = ""
    _.each Utensil.utensils, (utensil) ->
      html += JST['templates/utensil_picker']
        imageUrl: utensil.imageUrl
        name: utensil.name
    $('#utensils').html(html)
    $('#utensils a[data-utensil]').click (e) ->
      name = $(e.target).attr('data-utensil')
      utensil = Utensil.find(name)
      if utensil
        html = """
        <form data-utensil="#{name}" class="utensil-form" action="#{utensil.action}">
        #{utensil.formTemplate}
        <br>
        <input type="submit" value="Submit" class="btn btn-primary">
        </form>
        """
        $("#utensils").html(html)
        $form = $("#utensils .utensil-form")
        utensil.onFormLoad($form)
        $form.submit (e) ->
          output = $.extend({type: utensil.name}, utensil.processForm($form))
          Utensil.appendHtml(output)
          false
      else
        console.log "no utensil found for #{name}"
      false

  @push: (utensil) ->
    Utensil.utensils.push(new Utensil(utensil))

Utensil.push
  name: "Khan Academy Video"
  imageUrl: "http://upload.wikimedia.org/wikipedia/en/thumb/5/53/KhanAcademyLogo.png/200px-KhanAcademyLogo.png"
  formTemplate: """
  <p>Insert the youtube video ID for the Khan Academy video you want.</p>
  <input type="text" name="videoId">
  """
  processForm: ($form) ->
    {
      videoId: Utensil.encode($form.find('[name="videoId"]').val())
    }
  onFormLoad: ($form)->
    $('.utensil-form .search').keyup (e) ->
      $input = $(e.target)
      val = $input.val()
      #for search
  fromOpts: (opts)->
    if opts.videoId
      height = 360
      width = 640
      if window.innerWidth > 1180
        height = 480
        width = 853
      return """
      <iframe frameborder="0" scrolling="no" width="#{width}" height="#{height}" 
      src="http://www.khanacademy.org/embed_video?v=#{opts.videoId}" 
      allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe>
      """
    opts.embed

Utensil.push
  name: "Equation Helper"
  imageUrl: "https://chart.googleapis.com/chart?cht=tx&chl=x%20=%20%5Cfrac%7B-b%20%5Cpm%20%5Csqrt%20%7Bb%5E2-4ac%7D%7D%7B2a%7D"
  formTemplate: """
  <p>Enter an equation below.</p>
  <input type="text" name="equation" id="equation-picker">
  <img class="hid equation-helper"> 
  """
  processForm: ($form) ->
    {
      equation: Utensil.encode($form.find('[name="equation"]').val())
    }
  onFormLoad: ($form)->
    $form.find('#equation-picker').keyup ->
      $el = $(this)
      eq = encodeURIComponent($el.val())
      $('.equation-helper').show().attr('src', "https://chart.googleapis.com/chart?cht=tx&chl=#{eq}")
  fromOpts: (opts) ->
    """
    <img src="https://chart.googleapis.com/chart?cht=tx&chl=#{Utensil.encode(opts.equation)}">
    """

Utensil.push
  name: "Youtube Video"
  imageUrl: "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQQc92l8xuKIh9DZgobUXHVNiUWNd5DREO8JZAmBDABH6hd-w8uQw"
  action: "/search/youtube"
  formTemplate: """
  <p>Search for a youtube video</p>
  <input type="text" name="q">
  <ul class="youtube-results">
  </ul>
  <p class="active-video">Active Video:<strong>none</strong></p>
  <input type="hidden" name="video_id">
  """
  onFormLoad: ($form) ->
    $form.find('[name="q"]').keyup ->
      url = $form.attr("action") + "?" + $form.serialize()
      $.ajax
        url: url
        dataType: 'json'
        success: (data) ->
          console.log(data)
          if data.videos
            $('.youtube-results').html ''
            _.each data.videos, (vid) ->
              $li = $("<li><a href=\"#\" data-id='#{vid.id}' data-title='#{vid.title}'>#{vid.title}</a></li>")
              $('.youtube-results').append $li
            $('[data-id]').click (e) ->
              $el = $(e.target)
              $form.find('[name="video_id"]').val $el.data('id')
              $form.find('.active-video strong').text $el.data('title')
              false
      false
  processForm: ($form) ->
    {
      video_id: $form.find('[name="video_id"]').val()
    }
  fromOpts: (opts) ->
    height = 360
    width = 640
    if window.innerWidth > 1180
      height = 480
      width = 853
    """
    <iframe width="#{width}" height="#{height}" src="https://www.youtube.com/embed/Jb4JGX377Ok" frameborder="0" allowfullscreen></iframe>
    """

@Utensil = Utensil

