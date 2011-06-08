When /^I sign in with Google account "([^"]*)"$/ do |arg1|
 OmniAuth.config.add_mock :google, {
    'uid' => arg1,
    'user_info' => {'email' => arg1, 'name' => arg1}
    # etc.
  }
  visit '/auth/google'
end

Then /^I should be redirected to the welcome page$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the account confirmation page$/ do
  assert has_content? "new account"
  
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


Given /^user with Google account "([^"]*)" exists$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be redirected to dashboard$/ do
  pending # express the regexp above with the code you wish you had
end

