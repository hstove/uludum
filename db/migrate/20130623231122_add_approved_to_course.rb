class AddApprovedToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :approved, :boolean
  end
end
