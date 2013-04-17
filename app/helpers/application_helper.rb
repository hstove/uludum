module ApplicationHelper
  include MixpanelHelpers
  def icon style, white=false, opts={}
    clazz = "icon icon-#{style.to_s}"
    clazz << " icon-white" if white
    content_tag :i, '', opts.merge({class: clazz})
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
    if form.nil?
      html << send(:label, name, label_name, class: 'control-label')
    else
      html << form.send(:label, name, label_name, class: 'control-label')
    end
    html << '<div class="controls">'
    if form.nil?
      html << send(element.to_s+"_tag", name, nil, opts)
    else
      html << form.send(element, name, opts)
    end
    html << '</div></div>'
    html.html_safe
  end

  def avatar_tag user, opts={}
    opts[:class] ||= ""
    opts[:class] += " user-avatar"
    opts[:height] ||= opts[:width]
    opts[:width] ||= opts[:height]
    opts[:h] ||= opts[:height]
    opts[:w] ||= opts[:width]
    if opts[:height]
      style = "width: #{opts[:width]}px; height: #{opts[:height]}px;"
      opts[:style] = style
    end
    opts[:fit] ||= 'clip'
    filepicker_image_tag(user.avatar_url, opts).html_safe
  end

  def complete_title object, opts
    _title = object.title
    _title = icon(:ok) + " " + _title if complete? object
    link_to _title, object, opts
  end

  def user_display user, avatar_opts=nil, after_link=""
    avatar_opts ||= {height: 18, class: 'avatar-small'}
    link = user.username + "(#{user.points})"
    link = avatar_tag(user, avatar_opts) + link unless user.avatar_url.blank?
    link += after_link
  end

  def sidebar_list list, active=nil
    render partial: "layouts/sidebar_list", locals: {list: list, active: active}
  end

  def percent_gauge obj
    percent = logged_in? ? obj.percent_complete(current_user) : 0
    html = content_tag :canvas, nil, "data-percent" => percent, class: 'guage', height: 40, width: 70
    text = percent == 100 ? icon(:ok) : percent
    html << content_tag(:span, percent, class: 'gauge-percent')
  end

  def t title
    content_for :title, title
  end

  def pretty_date date
    date.strftime("%B %d, %Y at %l:%I %P")
  end

  def tracking_pixel message
    if Rails.env.production?
      p = mixpanel.tracking_pixel("Opened Email", { distinct_id: message.to.first, campaign: message.subject })
      return image_tag p, width: 1, height: 1
    end
    ""
  end

  def logo_tag size=250, opts={}
    if size > 500
      _size = 750
    elsif size > 250
      _size = 500
    elsif size > 75
      _size = 250
    else
      _size = 75
    end
    opts[:style] ||= ""
    image_tag "https://s3.amazonaws.com/uludum-assets/star#{_size}.png", width: size, height: size,
      style: "width: #{size}px; height: #{size}px;#{opts[:style]}"
  end
end
