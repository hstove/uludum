require 'spec_helper'

describe "PasswordResets" do
  describe "GET /password_resets" do
    it "emails the user when requesting password reset", js: true do
      user = create :user
      visit login_path
      click_link "password"
      fill_in "email", :with => user.email
      click_button "Reset Password"
      page.should have_content("An email has been sent with password reset instructions.")
    end
  end

  describe "edit" do
    it "changes the user's profile successfully", js: true do
      user = create :user
      user.send(:generate_token, :password_reset_token)
      user.save!
      visit "/password_resets/#{user.password_reset_token}/edit"
      fill_in "password", with: "testpassword"
      fill_in "password_confirmation", with: "testpassword"
      click_button "Reset Password"
      page.should have_content("You've successfully changed your password.")
      page.should have_content(user.username)
    end
  end
end
