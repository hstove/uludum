require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @section = create :section
  end

  def login user
    session[:user_id] = user.id
    @controller.stubs(:current_user).returns(user)
    @controller.stubs(:logged_in?).returns(true)
  end

  test "shouldn't show section unless enrolled" do
    get :show, id: @section
    assert_redirected_to root_url
    user = create(:user)
    user.enroll(@section.course_id)
    login(user)
    ap @section
    ap @section.course.enrolled_students
    ap user
    ap user.enrollments
    ap @section.course.enrollments
    ap @controller.current_user
    get :show, {id: @section}, {user_id: user.id}
    ap session[:user_id].to_i
    # ap @response
    assert_redirected_to root_url
    # assert_response :success
  end

  # test "should get index" do
  #   get :index
  #   assert_response :success
  #   assert_not_nil assigns(:sections)
  # end

  # test "should get new" do
  #   get :new
  #   assert_response :success
  # end

  # test "should create section" do
  #   assert_difference('Section.count') do
  #     post :create, section: { course_id: @section.course_id, position: @section.position, title: @section.title }
  #   end

  #   assert_redirected_to section_path(assigns(:section))
  # end

  # test "should show section" do
  #   get :show, id: @section
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get :edit, id: @section
  #   assert_response :success
  # end

  # test "should update section" do
  #   put :update, id: @section, section: { course_id: @section.course_id, position: @section.position, title: @section.title }
  #   assert_redirected_to section_path(assigns(:section))
  # end

  # test "should destroy section" do
  #   assert_difference('Section.count', -1) do
  #     delete :destroy, id: @section
  #   end

  #   assert_redirected_to sections_path
  # end
end
