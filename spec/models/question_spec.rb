require 'spec_helper'

describe Question do
  describe "Answering free answers" do
    before :each do
      @question = create :question
    end

    it "answers correctly" do
      @question.free_answer = 1.25
      @question.save

      q(1.25).should == true
      q(1.254).should == true
      q(1.250000).should == true
      q(1.255).should == true

      q(1.24).should == false
      q('what').should == false

      @question.free_answer = 1416
      @question.save

      q(1416).should == true

      @question.free_answer = 1416.10
      @question.save

      d?(1416.1).should == false #this is free_answer_correct
      q(1416.1).should == true
      
      @question.free_answer = "string"
      @question.save

      q('string').should == true
      q('stringy').should == false
    end

    it "knows when you need decimals" do
      @question.free_answer = 1.256348
      @question.save

      d?('wha').should == false
      d?('1a').should == false
      d?(1).should == false
      d?(1.26).should == false
      d?(1.256).should == false
      d?(1.2564).should == false
      d?(1.256348).should == false
      d?(1.2563483).should == false

      d?(1.2563).should == true
      d?(1.25635).should == true

      @question.free_answer = 1416
      @question.save

      d?(1416).should == false

      @question.free_answer = 1416.11
      @question.save

      d?(1416.1).should == true
      d?(1416).should == false
    end

    def q answer
      @question.free_answer_correct?(answer.to_s)
    end

    def d? answer, debug=false
      @question.needs_decimals?(answer.to_s, debug)
    end
  end
end
