class UserAnswer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  attr_accessible :correct, :user_id, :question_id, :answer_id

  before_create do |model|
    model.attempts = 0
    model.correct = false
    nil
  end

  validates_uniqueness_of :user_id, scope: :question_id
end
