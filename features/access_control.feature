Feature: Access Control
  In order to ensure the site is safe
  Users should only be able to take certain actions if logged in

  Scenario: I am not logged in and try to edit users
    When I go to users page
    Then I should be on the signin page

  Scenario: I am logged in as normal user and try to edit users
    Given I am logged in as a regular user
    When I go to the users page
    Then I should be on the dashboard
