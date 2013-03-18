require 'spec_helper'

describe Answer do
  before :each do
    @answer = create :answer
  end

  it "shouldn't save without question" do
    @answer.question_id = nil
    @answer.save.should be_false
  end

  it "shouldn't save without answer" do
    @answer.answer = nil
    @answer.save.should be_false
  end
end
