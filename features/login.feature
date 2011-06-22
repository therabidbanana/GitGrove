Feature: Login With Omniauth
  In order to allow easy login
  Users can use omniauth

  Scenario: Show Login
    Given I am on the home page
    When I follow the sign in link
    Then I should see a services link saying "Google"

  Scenario: I log in with existing google account
    Given I am on the signin page
    And user with Google account "david@osb.co" exists
    When I sign in with Google account "david@osb.co"
    Then I should be on the dashboard

  Scenario: I log in with first account
    Given I am on the signin page
    And there are no users
    When I sign in with Google account "foo@bar.com"
    Then I should see the account confirmation page
    When I confirm my account
    Then I should be on the dashboard
    And I should be an admin

  Scenario: I log in with new google account and confirm
    Given I am on the signin page
    When I sign in with Google account "foo@bar.com"
    Then I should see the account confirmation page
    When I change my name to "Bob Dole"
    And I change my email to "bob@bar.com"
    And I confirm my account
    Then I should be on the dashboard
    And I should see "welcome Bob Dole"

  Scenario: I try to register after admin
    Given user with Google account "david@osb.co" exists
    And I am on the signin page
    When I sign in with Google account "foo@bar.com"
    Then I should be on the home page
    And I should see "You do not appear to have an account"

  Scenario: Sign out
    Given I am logged in as an admin user
    And I am on the dashboard
    When I follow the sign out link
    Then I should be on the home page
    And I should no longer be logged in

