module PagesHelper
  def dynamo_welcome
    options = []
    options << course_link("Snowboarding", 114)
    options << course_link("Economics", 93)
    options << course_link("Robotics", 106)
    options << course_link("Medicine", 112)
    options << course_link("Physics", 56)
    links = dynamo_tag :span, options, speed: 130, delay: 2000
    content_tag :p, raw("Start Learning about #{links}")
  end

  private

  def course_link title, id
    course = Course.exists?(id) ? Course.find(id) : Course.first
    link_to title, course
  end
end
