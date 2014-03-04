require 'spec_helper'

describe DownloadsController do
  describe "GET show" do
    let(:course) { create :course }
    let(:download) { create :download, downloadable: course }
    let(:user) { create :user }
    let(:valid_session) { {user_id: user.id} }
    let(:params) { {course_id: download.downloadable, id: download.id} }

    it "doesn't show to unauthorized users" do
      get :show, params, valid_session
      response.redirect_url.should_not eql(download.url)
    end
    it "redirects to download.url" do
      user.enroll course
      get :show, params, valid_session
      response.should redirect_to(download.url)
    end
  end
end
