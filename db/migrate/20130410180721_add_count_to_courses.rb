class AddCountToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :questions_count, :integer
    add_column :categories, :courses_count, :integer
    remove_column :courses, :question_count
    remove_column :categories, :course_count
  end
end
