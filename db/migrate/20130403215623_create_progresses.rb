class CreateProgresses < ActiveRecord::Migration
  def change
    create_table :progresses do |t|
      t.string :progressable_type
      t.integer :progressable_id
      t.float :percent

      t.timestamps
    end
  end
end
