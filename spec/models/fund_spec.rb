require 'spec_helper'

describe Fund do
  let (:fund) { fund = create :fund, goal: 100, price: 10 }
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
      3.times { create(:order, orderable: fund) }
      fund.progress.should == 30
    end
  end

  describe "#after_save" do
    course = create :course, approved: true, hidden: false
    fund.course = course
    create :order, orderable: fund
    fund.stubs(:ready?).returns(true)
    Order.any_instance.should_receive(:complete)
    fund.save
  end
end