require 'spec_helper'

describe SubsectionsController do
  def valid_params section
    { 
      subsection: { 
        title: FactoryGirl.generate(:title),
        section_id: section.id,
        body: LoremIpsum::Generator.new.generate({})
      },
      section_id: section.id,
      course_id: section.course_id,
    }
  end

  def valid_session
    {
      user_id: @section.course.teacher_id
    }
  end

  # it "sets position on create" do
  #   subsection = create :subsection
  #   p = subsection.position
  #   post :create, valid_params(subsection.section), {user_id: subsection.course.teacher_id}
  #   assigns(:subsection).position.should be(p+1)
  # end

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

  it "redirects to course on delete" do
    subsection = create :subsection
    delete :destroy, {id: subsection.id}, {user_id: subsection.course.teacher_id}
    response.should redirect_to(course_path(subsection.course))
  end
  
end
