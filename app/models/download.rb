class Download < ActiveRecord::Base
  attr_accessible :title, :description, :url, :file_name, :file_type
  belongs_to :downloadable, polymorphic: true

  def course= new_course
    self.downloadable = new_course
  end

  def course
    downloadable
  end
end
