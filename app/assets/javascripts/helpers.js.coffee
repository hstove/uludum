$(document).ready ->
  $('.wysihtml5').each (i, el) ->
    $(el).wysihtml5
      parserRules:
        tags:
          iframe:
            remove: 0