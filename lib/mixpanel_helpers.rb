module MixpanelHelpers
  def track name, opts
    if Rails.env.production?
      if logged_in?
        opts[:distinct_id] ||= current_user.id
      end
      # @mixpanel.delay.track name, opts
      mixpanel.track name, opts
    end
  end

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new({ env: request.env, persist: true })
  end
end