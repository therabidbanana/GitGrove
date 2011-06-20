When /^I fill out the page with content$/ do |string|
  fill_in("page[content]", string)
  click_on "Submit"
end

When /^I visit the "([^"]*)" preview site$/ do |arg1|
  visit "/#{arg1}/index.html"
end


Then /^I should see a list of site files:$/ do |table|
  table.hashes.each do |pg|
    page.should have_css('.file', :contents => pg[:filename])
  end
end


