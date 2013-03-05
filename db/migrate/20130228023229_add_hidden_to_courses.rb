class AddHiddenToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :hidden, :boolean
  end
end
