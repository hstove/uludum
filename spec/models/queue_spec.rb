# require 'spec_helper'
# describe "queue" do

#   it "runs jobs on the queue" do
#     worker = Afterparty::Worker.new({sleep: 0.5})
#     worker.consume
#     @course = create :course
#     job = TestQueueJob.new @course, :title=, "new_title"
#     Rails.configuration.queue << job
#     sleep(5)
#     @course.reload
#     @course.title.should eq("new_title")
#     worker.stop
#   end

#   class TestQueueJob
#     def initialize obj, method, value
#       @obj = obj
#       @method = method
#       @value = value
#     end

#     def run
#       @obj.send @method, @value
#       @obj.save if @obj.respond_to? :save
#       @obj
#     end
#   end

# end