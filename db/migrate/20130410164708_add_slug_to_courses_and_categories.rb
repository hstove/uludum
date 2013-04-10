class AddSlugToCoursesAndCategories < ActiveRecord::Migration
  def change
    add_column :courses, :slug, :string, unique: true
    add_column :categories, :slug, :string, unique: true
  end
end
