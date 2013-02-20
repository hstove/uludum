class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :subsection_id
      t.integer :section_id
      t.string :prompt

      t.timestamps
    end
  end
end
