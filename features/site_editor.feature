Feature: Site Editor

  Background:
    Given I have a cleaned out sites directory
    Given I have a working site template
    And I am logged in as an admin user
    And I have created the following sites:
      | name   |  url      |
      | CF     | cf        |
  
  Scenario: I open a site to edit
    Given I am on the dashboard
    When I click on "Edit"
    Then I should see a list of site files:
      | filename |
      | index.md |
