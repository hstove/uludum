class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.integer :course_id
      t.integer :user_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
