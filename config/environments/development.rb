Ludum::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  # config.whiny_nils = true
  config.eager_load = false
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict


  config.cache_store = :null_store

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.middleware.insert_after(ActionDispatch::Static, Rack::LiveReload)

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
  config.action_mailer.default_url_options = {
    :host => "localhost",
    :port => 3000
  }

  # config.middleware.use ExceptionNotification::Rack,
  #   :email => {
  #     :email_prefix => "Error from Uludum",
  #     :sender_address => %{"error" <info@uludum.org>},
  #     :exception_recipients => %w{hstove@gmail.com},
  #     :sections => %w{ user_section } + ExceptionNotifier::EmailNotifier.default_sections
  #   }

  # config.middleware.use "Mixpanel::Middleware", ENV['MIXPANEL_TOKEN'], persist: true

  config.queue = TestQueue.new

end