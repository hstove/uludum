class AddCountsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :question_count, :integer
    add_column :categories, :course_count, :integer
  end
end
