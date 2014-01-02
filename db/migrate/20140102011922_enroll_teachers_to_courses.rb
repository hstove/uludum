class EnrollTeachersToCourses < ActiveRecord::Migration
  def change
    Course.all.each do |course|
      job = Afterparty::BasicJob.new course.user, :enroll, course
      Rails.configuration.queue << job
    end
  end
end
