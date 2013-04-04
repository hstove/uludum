class Progress < ActiveRecord::Base
  belongs_to :user
  belongs_to :progressable, polymorphic: true
  # has_paper_trail
  attr_accessible :user_id
  validates_presence_of :user_id, :progressable_id, :percent

  before_validation on: :create do
    self.percent ||= 0
  end
end



