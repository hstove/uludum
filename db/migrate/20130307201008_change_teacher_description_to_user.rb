class ChangeTeacherDescriptionToUser < ActiveRecord::Migration
  def change
    change_column :users, :about_me, :text
    change_column :users, :teacher_description, :text
  end
end
