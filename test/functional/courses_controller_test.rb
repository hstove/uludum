require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = create :course
  end

#   test "should get index" do
#     get :index
#     assert_response :success
#     assert_not_nil assigns(:courses)
#   end

#   test "should get new" do
#     get :new
#     assert_response :success
#   end

#   test "should create course" do
#     assert_difference('Course.count') do
#       post :create, course: { category: @course.category, description: @course.description, teacher_id: @course.teacher_id, title: @course.title }
#     end

#     assert_redirected_to course_path(assigns(:course))
#   end

#   test "should show course" do
#     get :show, id: @course
#     assert_response :success
#   end

#   test "should get edit" do
#     get :edit, id: @course
#     assert_response :success
#   end

#   test "should update course" do
#     put :update, id: @course, course: { category: @course.category, description: @course.description, teacher_id: @course.teacher_id, title: @course.title }
#     assert_redirected_to course_path(assigns(:course))
#   end

#   test "should destroy course" do
#     assert_difference('Course.count', -1) do
#       delete :destroy, id: @course
#     end

#     assert_redirected_to courses_path
#   end
end
