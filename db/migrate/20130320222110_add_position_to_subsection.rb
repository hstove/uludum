class AddPositionToSubsection < ActiveRecord::Migration
  def change
    add_column :subsections, :position, :integer
  end
end
