When /^I fill out the page with content$/ do |string|
  @my_content = string
  fill_in("content", :with => string)
  click_on "Save"
end

When /^I visit the "([^"]*)" preview site$/ do |arg1|
  visit "/#{arg1}/index.html"
end

Then /^I should see my new content$/ do
  page.should have_content(@my_content.strip)
end


Then /^I should see a list of site files:$/ do |table|
  table.hashes.each do |pg|
    page.should have_css('.file', :contents => pg[:filename])
  end
end


When /^I set the title to "([^"]*)"$/ do |arg1|
  fill_in("page_title", :with => arg1)
end

When /^I set the subtitle to "([^"]*)"$/ do |arg1|
  fill_in("extras-subtitle", :with => arg1)
end

