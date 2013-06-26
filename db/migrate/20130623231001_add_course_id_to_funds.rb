class AddCourseIdToFunds < ActiveRecord::Migration
  def change
    add_column :funds, :course_id, :integer
  end
end
