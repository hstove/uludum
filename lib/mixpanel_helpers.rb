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
    @mixpanel ||= Mixpanel::Tracker.new(ENV['MIXPANEL_TOKEN'], { persist: true })
  end
end