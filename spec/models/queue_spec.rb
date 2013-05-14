require 'spec_helper'
describe "queue" do
  it "runs jobs on the queue" do
    @course = create :course
    job = TestJob.new @course, :title=, "new_title"
    Rails.configuration.queue << job
    sleep(1)
    @course.reload
    @course.title.should eq("new_title")
  end

  class TestJob
    def initialize obj, method, value
      @obj = obj
      @method = method
      @value = value
    end

    def run
      @obj.send @method, @value
      @obj.save if @obj.respond_to? :save
      @obj
    end
  end

end