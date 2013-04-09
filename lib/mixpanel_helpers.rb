module MixpanelHelpers
  def track name, opts
    if Rails.env.production?
      # @mixpanel.delay.track name, opts
      mixpanel.track name, opts
    end
  end

  def mixpanel
    @mixpanel ||= Mixpanel::Tracker.new { env: request.env, persist: true }
  end
end