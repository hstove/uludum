module MixpanelHelpers
  def track name, opts
    if Rails.env.production?
      if logged_in?
        opts[:distinct_id] ||= current_user.id
        opts[:email] ||= current_user.email
        opts[:username] ||= current_user.username
      end
      # @mixpanel.delay.track name, opts
      mixpanel.track name, opts
    end
  end

  def mixpanel
    env = respond_to?("request") ? request.env : ENV
    @mixpanel ||= Mixpanel::Tracker.new({ env: env })
  end
end