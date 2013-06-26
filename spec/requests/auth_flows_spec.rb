require 'spec_helper'

describe "AuthFlows" do
  describe "GET /signup", js: true do
    it "works with good parameters" do

      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit signup_path
      fill_in :Username, with: FactoryGirl.generate(:username)
      fill_in "Email Address", with: FactoryGirl.generate(:email)
      fill_in "Enter Password", with: "password"
      fill_in "Confirm Password", with: "password"
      click_on 'Sign up'
      # screenshot!
      current_path.should == "/users/how"
      page.should have_content "Welcome to Uludum!"
      # page.driver.save_screenshot "tmp/yo.png", height: 800
    end
  end
end
