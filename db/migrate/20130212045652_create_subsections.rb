class CreateSubsections < ActiveRecord::Migration
  def change
    create_table :subsections do |t|
      t.integer :section_id
      t.integer :course_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
