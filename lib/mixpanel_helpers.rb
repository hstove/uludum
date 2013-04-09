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
    @mixpanel ||= Mixpanel::Tracker.new({ env: request.env })
  end
end