Feature: Login With Omniauth

  Scenario: Show Login
    Given I am on the home page
    When I follow "sign up or sign in"
    Then I should see a link saying "Google"

  Scenario: I log in with new google account and confirm
    Given I am on the signin page
    When I sign in with Google account "foo@bar.com"
    Then I should see the account confirmation page
    When I change my name to "Bob Dole"
    And I change my email to "bob@bar.com"
    And I confirm my account
    Then I should be on the welcome page
    And I should see "welcome Bob Dole"

  Scenario: I log in with existing google account
    Given I am on the signin page
    And user with Google account "david@osb.co" exists
    When I sign in with Google account "david@osb.co"
    Then I should be on the dashboard page
