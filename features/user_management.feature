Feature: User Management
  Background:
    Given I am logged in as an admin user
    And user with Google account "david@osb.co" exists

  Scenario: I am logged in as admin with 1 regular user
    When I go to the users page
    Then I should see a list with 2 users

  Scenario: I delete a user
    When I go to the users page
    And click on "Delete"
    Then I should see a list with 1 users
    And I should see 0 delete links

  Scenario: I should not be able to delete myself
    When I go to the users page
    Then I should see 1 delete link
  
  Scenario: I create a new user
    When I go to the users page
    And I click on "Add another?"
    And I fill in user info:
      | name  | email              | is_admin |
      | David | david@example.com  | true     |
    And I press "Create"
    Then I should see a list with 3 users
    And I should see a login link for "david@example.com"
