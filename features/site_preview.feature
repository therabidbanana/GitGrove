Feature: Site Preview
  Background:
    Given I have a cleaned out sites directory
    And I have a working site template
    And I am logged in as an admin user
    And I have created the following sites:
      | name   |  url      |
      | CF     | cf        |
    And jobs are dispatched
  
  Scenario: I go to preview
    When I visit the preview site for "cf"
    Then I should see "This is the index"
