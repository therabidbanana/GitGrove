Given /^I have the following sites:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |h|
    Site.create(h)
  end
end

Given /^I have created the following sites:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |h|
    visit '/sites/new'
    fill_in('site[name]', :with => h[:name])
    fill_in('site[url]', :with => h[:url])
    click_on("Create")
  end
end

Given /^a template repo exists$/ do
  create_template_repo
end


When /^I fill in site form with:$/ do |table|
  # table is a Cucumber::Ast::Table
  hash = table.hashes.first
  fill_in('site[name]', :with => hash[:name])
  fill_in('site[url]', :with => hash[:url])
end

Then /^I should see a flash "([^"]*)"$/ do |arg1|
  within(".flash.error") do
    assert has_content?(arg1)
  end
end

Then /^I should see a list with (\d+) sites?$/ do |arg1|
  within('#site_list') do
    page.should have_css('.site', :count => arg1.to_i)
  end
end

Then /^there should be a "([^"]*)" repo$/ do |arg1|
  assert repo_exists?(arg1)
end

Then /^there should be not be a "([^"]*)" repo$/ do |arg1|
  assert !repo_exists?(arg1)
end

Then /^there should be a "([^"]*)" repo with template setup$/ do |arg1|
  assert repo_exists?(arg1)
  assert repo_inherits_hook?(arg1)
end

Then /^I should not see a "([^"]*)" link$/ do |arg1|
  assert !has_content?(arg1)
end


