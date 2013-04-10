module CoursesHelper
  def categories_options_tag(course)
    cats = []
    Categories.all.each do |c|
      cats << [c.id, c.name.titleize]
    end
    options_for_select(cats, course.category_id)
  end

  def progress
    course = current_course
    return nil unless enrolled?(course)
    p = course.percent_complete(current_user)
    old_progress = session["progress_#{course.id}"] || p
    session["progress_#{course.id}"] = p
    progress_tag p, old_progress
  end

  def progress_tag p, old_progress=nil
    old_progress ||= p
    bar = content_tag(:div, '', style: "width: #{old_progress}%;", progress: p, old_progress: old_progress, class: 'bar')
    # percent = content_tag(:span, "#{old_progress}%")
    # container = content_tag(:div, bar + percent, class: 'progress progress-success')
    container = content_tag(:div, bar, class: 'progress progress-success')
    area_opts = {
      class: 'progress-area'
    }
    area_opts.merge!({
      'data-toggle' => 'tooltip',
        title: "#{p}% Complete",
        'data-placement' => 'bottom'
    }) #if p.to_i > 88
    area = content_tag(:div, container, area_opts)
  end
end
