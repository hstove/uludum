module CapybaraMacros
  def login(user, password)
    visit login_path
    fill_in :login, with: user.username
    fill_in :password, with: password
    click_on 'Log in'
  end

  def screenshot!
    page.driver.save_screenshot (img_path = "tmp/screenshot_#{Time.now.to_i}.png"), height: 800
    Launchy.open(img_path)
  end
end