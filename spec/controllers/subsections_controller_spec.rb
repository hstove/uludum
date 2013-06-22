require 'spec_helper'

describe SubsectionsController do
  def valid_params section
    { 
      subsection: { 
        title: FactoryGirl.generate(:title),
        section_id: section.id,
        body: LoremIpsum::Generator.new.generate({})
      },
      section_id: section.id 
    }
  end

  def valid_session
    {
      user_id: @section.course.teacher_id
    }
  end

  it "sets position on create" do
    @section = create :section
    section = @section
    get :create, valid_params(section), valid_session
    assigns(:subsection).section.should_not be(nil)
    assigns(:subsection).position.should_not be(nil)
    p = assigns(:subsection).position
    get :create, valid_params(section), valid_session
    assigns(:subsection).position.should be(p+1)
  end

  it "renders show subsection if enrolled" do
    subsection = create :subsection
    user = create :user
    user.enroll subsection.course
    get :show, {id: subsection.id}, { user_id: user.id }
    response.should be_success
  end

  it "doesn't show subsection if unenrolled" do
    subsection = create :subsection
    user = create :user
    get :show, {id: subsection.id}, { user_id: user.id }
    response.should redirect_to(course_path(subsection.course))
  end
  
end
