Feature: Site Assets
  As a user
  I should be able to upload new assets and see current ones

  Background:
    Given I have a cleaned out sites directory
    Given I have a working site template
    And I am logged in as an admin user
    And I have created the following sites:
      | name   |  url      |
      | CF     | cf        |
    And jobs are dispatched

  Scenario: List of files
    Given I am on the edit "cf" dashboard
    When I click on "View Assets"
    Then I should be on assets "cf" dashboard
    

