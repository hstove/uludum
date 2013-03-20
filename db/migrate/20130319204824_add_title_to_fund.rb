class AddTitleToFund < ActiveRecord::Migration
  def change
    add_column :funds, :title, :string
  end
end
