class CreateCompletions < ActiveRecord::Migration
  def change
    create_table :completions do |t|
      t.integer :subsection_id
      t.integer :user_id

      t.timestamps
    end
  end
end
