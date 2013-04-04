class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  attr_accessible :answer, :question_id, :correct

  validates_presence_of :answer, :question_id
end
