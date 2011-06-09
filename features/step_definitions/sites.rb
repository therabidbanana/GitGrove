Given /^I have the following sites:$/ do |table|
  # table is a Cucumber::Ast::Table
  table.hashes.each do |h|
    Site.create(h)
  end
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
  save_and_open_page
  within('#site_list') do
    page.should have_css('.site', :count => arg1.to_i)
  end
end

Then /^there should be a "([^"]*)" repo$/ do |arg1|
  assert File.exists?(File.join(Yetting.repo_storage_path, "#{arg1}.git"))
end


