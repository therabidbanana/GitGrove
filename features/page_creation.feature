Feature: Page Creation

  Background:
    Given I have a cleaned out sites directory
    Given I have a working site template
    And I am logged in as an admin user
    And I have created the following sites:
      | name   |  url      |
      | CF     | cf        |
    And jobs are dispatched
    
  Scenario: I create a new page
    Given I am on the edit "cf" dashboard
    When I click on "Create a New Page"
    Then I should see an edit screen

  Scenario: I delete a page
    Given I am on the edit "cf" dashboard
    And I have created page "foobar"
    Then there should be 2 pages
    When I click "Delete" for page "foobar"
    Then I should be on the edit "cf" dashboard
    And there should be 1 page


