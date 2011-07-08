Feature: Site Editor

  Background:
    Given I have a cleaned out sites directory
    Given I have a working site template
    And I am logged in as an admin user
    And I have created the following sites:
      | name   |  url      |
      | CF     | cf        |
    And jobs are dispatched
  
  Scenario: I open a site to edit
    Given I am on the dashboard
    When I click on "Edit"
    Then I should see a list of site files:
      | filename |
      | index.md |

  Scenario: I edit a page
    Given I am on the edit "cf" dashboard
    When I click on "index"
    And I fill out the page with content
      """
        this is my new content
      """
    Then eventually the preview site for "cf" should include "this is my new"

  Scenario: I edit a page title
    Given I am on the edit "cf" dashboard
    When I click on "index"
    And I set the title to "foobar"
    And I press "Save"
    Then eventually the preview site for "cf" should include "foobar"

