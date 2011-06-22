When /^I?\s?click on "([^"]*)"$/ do |arg1|
  click_link(arg1)
end

When /^I fill in user info:$/ do |table|
  # table is a Cucumber::Ast::Table
  hash = table.hashes.first
  fill_in('user[name]', :with => hash[:name])
  fill_in('user[email]', :with => hash[:email])
  uncheck('user[is_admin]')
  check('user[is_admin]') if hash[:is_admin]
end


Then /^I should see a list of users$/ do
  page.should have_css("ul#user_list li")

end
Then /^I should see a list with (\d+) users?$/ do |count|
  page.should have_css("ul#user_list li", :count => count.to_i)
end

Then /^I should see (\d+) delete links?$/ do |count|
  if count.to_i == 0
    page.should_not have_css("ul#user_list li a", :content => 'Delete')
  else
    page.should have_css("ul#user_list li a", :count => count.to_i, :content => 'Delete')
  end
end

Then /^I should see (\d+) "(.*)" links?$/ do |count, text|
  if count.to_i == 0
    page.should_not have_css("ul#user_list li a", :content => text)
  else
    page.should have_css("ul#user_list li a", :count => count.to_i, :content => text)
  end
end


