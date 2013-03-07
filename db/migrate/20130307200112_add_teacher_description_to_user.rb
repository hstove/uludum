class AddTeacherDescriptionToUser < ActiveRecord::Migration
  def change
    add_column :users, :teacher_description, :string
    add_column :users, :about_me, :string
  end
end
