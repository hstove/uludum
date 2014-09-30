module PagesHelper
  def dynamo_welcome
    options = []
    options << course_link("Snowboarding", 114)
    options << course_link("Teaching", 117)
    options << course_link("Economics", 93)
    options << course_link("Robotics", 106)
    options << course_link("Medicine", 112)
    options << course_link("Physics", 56)
    links = dynamo_tag :span, options, speed: 130, delay: 2000
    content_tag :p, raw("See an example course about #{links}")
  end

  private

  def course_link title, id
    course = Course.exists?(id) ? Course.find(id) : Course.first
    link_to title, course
  end

  def how_it_works(step_num, &block)
    haml_tag '.row' do
      haml_tag '.span1' do
        haml_tag('span.intro-step', step_num)
      end
      haml_tag '.span7', &block
    end
    haml_tag "br"
    haml_tag ".break-dark"
    haml_tag "br"
  end
end
