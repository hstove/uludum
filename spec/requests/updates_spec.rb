require 'spec_helper'

describe "Updates" do
  let(:updateable) { create :fund, hidden: false }
  let(:update) { create :update }

  it "shows that no updates exists", js: true do
    visit fund_path(updateable)
    page.should_not have_content("0 Updates")
    page.should_not have_content("New Update")
  end

  it "can navigate to updates", js: true do
    update.updateable = updateable
    update.save!
    visit fund_path(updateable)
    page.should have_content "1 Update"
    click_on "1 Update"
    current_url.should include(fund_updates_path(updateable))
    page.should have_content(update.title)
    page.should have_content(update.body.html_safe)
  end

  context "as creator" do
    let(:user) { create :user }
    it "can create new updates", js: true do
      updateable.user = user
      updateable.save
      login user, "password"
      visit fund_path(updateable)
      visit new_fund_update_path(updateable)
      title = FactoryGirl.generate(:title)
      body = FactoryGirl.generate(:body)
      fill_in "update_title", with: title
      page.driver.evaluate_script("$('#update_body').html('#{body}')")
      click_on "Save"
      current_url.should include(fund_path(updateable))
      click_on "1 Update"
      page.should have_content(title)
    end
  end
end
