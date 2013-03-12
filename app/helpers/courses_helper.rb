module CoursesHelper
  def categories_options_tag
    cats = []
    Course.categories.each do |c|
      cats << [c.category, c.category]
    end
    options_for_select(cats)
  end

  def progress
    course = current_course
    return nil unless logged_in? && enrolled?(course)
    p = course.percent_complete(current_user)
    bar = content_tag(:div, '', style: "width: #{p}%;", class: 'bar')
    container = content_tag(:div, bar, class: 'progress progress-success')
    area_opts = {
      class: 'progress-area',
        'data-toggle' => 'tooltip',
        title: "#{p}% Complete",
        'data-placement' => 'bottom'
    }
    area = content_tag(:div, container, area_opts)
  end
end
