module MixpanelHelpers
  def track name, opts={}
    if Rails.env.production?
      if logged_in?
        opts[:distinct_id] ||= current_user.id
        opts[:email] ||= current_user.email
        opts[:username] ||= current_user.username
      end
      # @mixpanel.delay.append_track name, opts
      mixpanel.append_track name, opts
    end
  end

  def track_charge order
    mixpanel.track_charge(order.user.id, order.price) if Rails.env.production?
  end

  def mixpanel
    env = {
      'REMOTE_ADDR' => request.env['REMOTE_ADDR'],
      'HTTP_X_FORWARDED_FOR' => request.env['HTTP_X_FORWARDED_FOR'],
      'rack.session' => request.env['rack.session'],
      'mixpanel_events' => request.env['mixpanel_events']
    }

    @mixpanel ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'], { env: env, persist: true })
  end
end