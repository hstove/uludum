class AddBannerUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :banner_url, :string
  end
end
