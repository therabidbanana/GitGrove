Then /^I should see a list of site files:$/ do |table|
  table.hashes.each do |pg|
    page.should have_css('p.file', :contents => pg[:filename])
  end
end

