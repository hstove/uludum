class RemoveCategoryFromCourses < ActiveRecord::Migration
  def change
    remove_column :courses, :category
  end
end
