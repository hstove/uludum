/*!
 * dynamo.js
 * http://prezjordan.github.io/dynamo.js
 *
 * Copyright 2013 Jordan Scales (http://jordanscales.com)
 * Released under the MIT license
 * See LICENSE.txt
 *
 * Date: 2013-05-04
 */

(function($) {

  $.fn.dynamo = function(options) {

    return this.each(function(i, v) {
      options = options || {};

      // select the element v
      var v$ = $(v);

      // we mark launched dynamos as "intialized" then check so we don't initialize them twice
      if (v$.data('initialized') == 'true')
        return;
      
      var delay = options.delay || parseInt(v$.data('delay')) || 3000;
      var speed = options.speed || parseInt(v$.data('speed')) || 350;
      var pause = options.pause || v$.data('pause') || false;
      var lines = options.lines || v$.data('lines').split(v$.data('delimiter') || ',');
      var callback = options.callback || v$.data('callback') || function() {};
      var centered = options.centered || v$.data('center') || false;

      // wrap the original contents in a span
      v$.html($('<span></span>').html(v$.html())).data('initialized', 'true');

      // grab the width of the span
      var max = v$.find('span:eq(0)').width();

      // for each item in data-lines, create a span with item as its content
      // compare the width of this span with the max
      for (k in lines) {
        var span = $('<span></span>').html(lines[k]);

        v$.append(span);
        max = Math.max(max, span.width());
      }

      // replace all the spans with inline-div$'s
      v$.find('span').each(function(i, ele) {
        var old$ = $(ele).remove();
        var div$ = $('<div></div>').html(old$.html());

        if (!i) {
          // our last element gets tagged
          div$.data('trigger', 'true');
        }

        div$.width(max);
        v$.append(div$);
      });

      // set the height of the dynamo container
      var height = v$.find('>:first-child').height();

      // style
      v$.width(max)
        .height(height)
        .css({
          'display' : 'inline-block',
          'position' : 'relative',
          'overflow' : 'hidden',
          'vertical-align' : 'bottom',
          'text-align' : 'left'
        });

      // manually center it if we need to
      if (centered)
        v$.css('text-align', 'center');

      // now, animate it
      var transition = function() {
        v$.dynamo_trigger({ speed: speed, callback: callback });
      };

      if (!pause) {
        setInterval(transition, delay);
      }
    });
  };
  
  $.fn.dynamo_trigger = function(options) {

    return this.each(function(i, v) {
      options = options || {}

      var v$ = $(v);
      var speed = options.speed || v$.data('speed') || 350;
      var callback = options.callback || v$.data('callback') || function() {};

      v$.find('div:first').slideUp(speed, function() {
        v$.append($(this).show());

        // check if the first item has made its way to the top again
        if (v$.find('div:first').data('trigger') == 'true')
          eval(callback).call();
      });
    });
  };

  // automatically initiate cycles on elements of class 'dynamo'
  $('.dynamo').dynamo();

})(jQuery);