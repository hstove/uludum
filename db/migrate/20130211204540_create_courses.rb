class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.integer :teacher_id
      t.string :category

      t.timestamps
    end
  end
end
