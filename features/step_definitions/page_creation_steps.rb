
Then /^I should see an edit screen$/ do
  page.should have_css('#gollum-editor form')
end

Given /^I have created page "([^"]*)"$/ do |arg1|
  click_on('Create a New Page')
  fill_in('gollum-editor-page-title', :with => arg1)
  click_on('Save')
end

When /^I click "([^"]*)" for page "([^"]*)"$/ do |arg1, arg2|
  within(".file_row##{arg2}") do
    click_on('Delete')
  end
end

Then /^there should be (\d+) pages?$/ do |arg1|
  page.should have_css('.file_row', :count => arg1.to_i)
end

