class Completion < ActiveRecord::Base
  belongs_to :user
  belongs_to :subsection
  
  after_save do
    Rails.configuration.queue << Afterparty::BasicJob.new(subsection, :calc_percent_complete, user)
    # subsection.calc_percent_complete(user)
  end
  
  attr_accessible :subsection_id, :user_id
end
