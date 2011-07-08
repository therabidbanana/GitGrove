Given /^jobs are dispatched$/ do
  success, failures = Delayed::Worker.new.work_off
  success.should > 0
end

Then /^eventually the preview site for "(.*)" should include "(.*)"$/ do |site, text|
  When("I visit the preview site for \"#{site}\"")
  Then("I should see \"Site rebuilding\"")
  Given("jobs are dispatched")
  When("I visit the preview site for \"#{site}\"")
  Then("I should see \"#{text}\"")
  Then("I should not see \"Site rebuilding\"")
end

Then /^eventually the preview site for "(.*)" should include "(.*)" as a header$/ do |site, text|
  When("I visit the preview site for \"#{site}\"")
  Then("I should see \"Site rebuilding\"")
  Given("jobs are dispatched")
  When("I visit the preview site for \"#{site}\"")
  Then("the page should include \"#{text}\" as a header")
  Then("I should not see \"Site rebuilding\"")
end


Given /^I have a cleaned out sites? directory$/ do
  clean_out_sites_dir
end

Given /^I have a working site template$/ do
  create_working_template
end

Given /^I have a working clone of "([^"]*)"$/ do |arg1|
  site = Site.find_by_url(arg1)
  working_clone_for(site)
end

When /^I edit the index of "([^"]*)" to have markdown body$/ do |site, string|
  clone = find_clone(site)
  git_index = clone.index
  index_file_path = File.join(clone_path(site), 'content', 'index.md')
  edit_file(index_file_path, string)
  # git_index.add(index_file_path, string)
  # git_index.commit('committing changes', [clone.heads.first.commit])
end

When /^I commit and push changes to "([^"]*)"$/ do |site|
  clone = find_clone(site)
  commit_all_changes(clone_path(site))
  push_changes(clone_path(site))
  real_site = Site.find_by_url(site)
  # Force rebuild
  visit rebuild_site_path(real_site, :token => real_site.rebuild_token)
end

When /^I visit the preview site for "([^"]*)"$/ do |arg1|
  visit "/#{arg1}/index.html"
end

Then /^the page should include "([^"]*)" as a header$/ do |arg1|
  page.should have_css('h1,h2', :text => arg1)
end

