class CreateUpdates < ActiveRecord::Migration
  def change
    create_table :updates do |t|
      t.string :updateable_type
      t.integer :updateable_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
