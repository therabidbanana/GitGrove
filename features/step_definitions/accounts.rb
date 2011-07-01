Given /^user with Google account "([^"]*)" exists$/ do |arg1|
  create_google_user(arg1)
end

Given /^there are no users$/ do
  assert User.all.size == 0
end

Given /^I am logged in as a regular user$/ do
  u = create_google_user("test@example.com")
  u.is_admin = false
  u.save
  OmniAuth.config.add_mock :google, {
    'uid' => u.email,
    'user_info' => {'email' => u.email, 'name' => u.email}
    # etc.
  }
  visit '/auth/google'
end

Given /^I am logged in as an admin user$/ do
  u = create_google_user("test@example.com")
  u.is_admin = true
  u.save
  OmniAuth.config.add_mock :google, {
    'uid' => u.email,
    'user_info' => {'email' => u.email, 'name' => u.email}
    # etc.
  }
  visit '/auth/google'
end


When /^I sign in with Google account "([^"]*)"$/ do |arg1|
 OmniAuth.config.add_mock :google, {
    'uid' => arg1,
    'user_info' => {'email' => arg1, 'name' => arg1}
    # etc.
  }
  visit '/auth/google'
end

When /^I follow the sign in link$/ do
  click_link("Log in")
end

When /^I follow the sign out link$/ do
  click_link("Log out")
end

Then /^I should no longer be logged in$/ do
  page.should have_content('You have been signed out')
end


When /^I change my name to "([^"]*)"$/ do |arg1|
  fill_in('name', :with => arg1)
end

When /^I change my email to "([^"]*)"$/ do |arg1|
  fill_in('email', :with => arg1)
end


When /^I confirm my account$/ do
  click_button("commit")
end

When /^I confirm my account with "([^"]*)" and "([^"]*)"$/ do |name, email|
  fill_in('name', :with => name)
  fill_in('email', :with => email)

  click_button("commit")
end


Then /^I should see a services link saying "([^"]*)"$/ do |arg1|
  within("#services_list") do
    assert has_content? arg1
  end
  
end

Then /^I should see the account confirmation page$/ do
  assert has_content? "new account"
  
end


Then /^I should be an admin$/ do
  assert has_content? "Manage Users"
end

When /^I try to log in with the token "([^"]*)"$/ do |arg1|
  visit "/auth/token?token=#{arg1}"
end



Given /^user with token "([^"]*)" exists$/ do |arg1|
  u = User.create(:name => 'Test', :email => 'test@example.com')
  s = Service.find_by_user_id_and_provider(u.id, 'token')
  s.uid = arg1
  s.save
  OmniAuth.config.add_mock :token, {
    'uid' => arg1,
    'user_info' => {'email' => u.email, 'name' => u.email}
    # etc.
  }
end

