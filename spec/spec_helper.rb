require 'rubygems'
module ActiveModel; module Observing; end; end
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'mocha/setup'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.include CapybaraMacros
  config.include MailerMacros
  config.include SpecMacros
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # don't run performance tests every time
  config.filter_run_excluding :performance => true, js: true

  config.before{ Rails.configuration.queue.clear }

  # When we're running a performance test load the test fixures:
  config.before(:each, :performance => true) do
    return if Course.count > 150

    Course.destroy_all

    pbar = ProgressBar.create(title: 'boostrapping for performance test', total: 6250)

    # load performance fixtures
    50.times do
      course = create :course
      pbar.increment
      5.times do
        user = create :user
        user.enroll(course.id)
        section = create :section, course: course
        pbar.increment
        5.times do
          sub = create :subsection, section: section
          pbar.increment
          5.times do
            q = create :question, subsection: sub
            pbar.increment
          end
        end
      end
    end

    require 'database_cleaner'
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      reset_email
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    config.after(:each, js: true) do
      if example.exception != nil
        screenshot!
      end
    end

    config.after do
      Rails.configuration.queue.clear
    end
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end





