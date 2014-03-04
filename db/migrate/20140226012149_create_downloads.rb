class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :url
      t.string :title
      t.text :description
      t.string :file_type
      t.string :file_name
      t.string :downloadable_type
      t.integer :downloadable_id

      t.timestamps
    end
  end
end
