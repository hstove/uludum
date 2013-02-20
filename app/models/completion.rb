class Completion < ActiveRecord::Base
  belongs_to :user
  belongs_to :subsection
  
  attr_accessible :subsection_id, :user_id
end
