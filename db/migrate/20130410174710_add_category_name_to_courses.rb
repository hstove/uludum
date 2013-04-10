class AddCategoryNameToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :category_name, :string
  end
end
