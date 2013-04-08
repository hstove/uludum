class AddPolymorphicToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :discussable_type, :string
    add_column :discussions, :discussable_id, :integer
  end
end
