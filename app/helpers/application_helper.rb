module ApplicationHelper
  def icon style, white=false
    i = "<i class=\"icon icon-#{style.to_s}"
    i << " icon-white" if white
    i << "\"></i>"
    i.html_safe
  end

  def percent_complete
    return nil unless logged_in?
    course = current_course
    return nil if course.nil? or !enrolled?(course)
    course.percent_complete(current_user)
  end

  def current_course
    course = nil
    if !@course.nil?
      course = @course
    elsif !@section.nil?
      course = @section.course
    elsif !@subsection.nil?
      course = @subsection.course
    end
  end

  def form_element form, name, element, label_name=nil, opts={}
    label_name ||= name.to_s.humanize
    if opts.class == Hash
      if opts[:class]
        unless opts[:class].include? "input-"
          opts[:class] += " input-xxlarge"
        end
      else
        opts[:class] = "input-xxlarge"
      end
      if element == :text_area
        if !opts[:rows]
          opts.merge!(rows: 10)
        end
        if !opts[:class].include?('simple') && !opts[:class].include?('wysihtml5')
          opts[:class] += " wysihtml5"
        end
      end
    end
    html = '<div class="field control-group">'
    html << form.send(:label, name, label_name, class: 'control-label')
    html << '<div class="controls">'
    html << form.send(element, name, opts)
    html << '</div></div>'
    html.html_safe
  end

end
