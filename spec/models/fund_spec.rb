require 'spec_helper'

describe Fund do
  let (:fund) { create :fund, goal: 100, price: 10 }
  describe "#ready?" do
    it { fund.ready?.should == false }

    it "returns true if finished? and course.ready?" do
      course = create :course
      fund.course = course
      course.stubs(:ready?).returns(true)
      fund.stubs(:finished?).returns(true)
      fund.ready?.should == true
    end
  end

  describe "finished?" do
    it "returns true if progress >= goal" do
      fund.stubs(:progress).returns(100)
      fund.finished?.should == true
    end

    it { fund.finished?.should == false }
  end

  describe "#progress" do
    it { fund.progress.should == 0 }

    it "calculates progress correctly" do
      3.times { create(:order, orderable: fund, price: 10) }
      fund.progress.should == 30
    end
  end

  describe "#open" do

    context "not ended" do
      let(:fund) { create :fund, goal_date: Time.now + 2.days }

      it { fund.open?.should == true }
      it { Fund.open.should include(fund) }
    end

    context "not ended" do
      let(:fund) { create :fund, goal_date: 2.days.ago }

      it { fund.open?.should == false }
      it { Fund.open.should_not include(fund) }
    end
  end
end