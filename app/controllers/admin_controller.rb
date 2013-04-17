class AdminController < ApplicationController
  before_filter :require_admin

  def dashboard
    Rails.application.eager_load!
    @models = ActiveRecord::Base.descendants
  end

end
