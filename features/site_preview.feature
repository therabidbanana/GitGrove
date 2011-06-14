Feature: Site Preview
  Background:
    Given I have a working site template
    And I am logged in as an admin user
    And I have created the following sites:
      | name   |  url      |
      | CF     | cf        |
  
  Scenario: I go to preview
    When I visit the preview site for "cf"
    Then I should see "This is the index"
