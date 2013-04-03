# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Utensil
  name: null
  imageUrl: null
  formTemplate: null
  currentTextarea: null
  @utensils: []

  processForm: ($form) ->

  onFormLoad: ->

  constructor: (opts) ->
    $.extend @, opts

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
        <form data-utensil="#{name}" class="utensil-form">
        #{utensil.formTemplate}
        <br>
        <input type="submit" value="Submit" class="btn btn-primary">
        </form>
        """
        $("#utensils").html(html)
        utensil.onFormLoad()
        $form = $("#utensils .utensil-form")
        $form.submit (e) ->
          output = $.extend({type: utensil.name}, utensil.processForm($form))
          Utensil.appendHtml(output)
          false
      else
        console.log "no utensil found for #{name}"
      false

  @push: (utensil) ->
    Utensil.utensils.push(utensil)

Utensil.push(new Utensil({
  name: "Khan Academy Video"
  imageUrl: "http://upload.wikimedia.org/wikipedia/en/thumb/5/53/KhanAcademyLogo.png/200px-KhanAcademyLogo.png"
  formTemplate: """
  <p>Copy and Paste the embed code from KhanAcademy.org</p>
  <textarea name="embed" rows=6 columns=40></textarea>
  """
  processForm: ($form) ->
    {
      youtube_id: Utensil.encode($form.find('[name="youtube_id"]').val())
    }
  onFormLoad: ->
    $('.utensil-form .search').keyup (e) ->
      $input = $(e.target)
      val = $input.val()
  })
)

@Utensil = Utensil

