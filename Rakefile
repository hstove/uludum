#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require File.expand_path('../lib/khan', __FILE__)
require 'json'

Ludum::Application.load_tasks

desc "reset position for all sections and subsection"
task reset_positions: :environment do
  Course.find(:all).each do |course|
    ap "\n\ncourse:\n#{course.title}\n"
    course.sections.each_with_index do |section, i|
      section.position = i + 1
      section.save
      ap "\nsection:\n#{section.title}"
      section.subsections.each_with_index do |sub, i2|
        sub.position = i2 + 1
        sub.save
        ap "subsection:\n#{sub.title}"
        sub.questions.each_with_index do |q, i3|
          q.position = i3+1
          q.save
        end
      end
    end
  end
end

task calc_all_course_progress: :environment do
  Course.all.each do |course|
    course.update_all_progress
  end
end

task convert_khan_videos: :environment do
  Subsection.all.each do |sub|
    if sub.body.include? "iframe"
      videoId = sub.body[/\?v=(.?{11})/][-11..-1]
      opts = {
        type: "Khan Academy Video",
        videoId: videoId
      }
      body = "<utensil>#{opts.to_json}</utensil>"
      ap "converting"
      puts sub.body
      ap "to"
      puts body
      sub.body = body
      sub.save
    end
  end
end

task reset_counters: :environment do
  Course.all.each do |course|
    Course.reset_counters(course.id, :questions)
  end
  Category.all.each do |category|
    Category.reset_counters(category.id, :courses)
  end
end

task fulfill_funds: :environment do
  live_funds = Fund.where(live: true).where("goal_date < ?", DateTime.now)
  live_funds.each do |fund|
    if fund.course && fund.course.approved
      if fund.progress > fund.goal
        fund.orders.each do |order|
          order.complete
        end
      end
    end
  end
end

