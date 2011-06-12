Feature: Sites List
  In order to manage websites
  Background:
    Given I have a cleaned out site directory

  Scenario: I try to go to the dashboard without authenticating
    When I go to the dashboard
    Then I should be on the signin page
  
  Scenario: I try to create a site without being an admin
    Given I am logged in as a regular user
    When I go to the new site page
    Then I should be on the dashboard
    And I should see a flash "You don't have admin access!"

  Scenario: I can't delete sites if I'm not an admin
    Given I am logged in as a regular user
    And I have the following sites:
      | name   |  url      |
      | CF     | cf.osb.co |
      | Bubble | bub.osb.co|
    When I go to the dashboard
    Then I should not see a "Delete" link

  Scenario: I create a site
    Given I am logged in as an admin user
    When I go to the new site page
    And I fill in site form with:
      | name | url       |
      | CF   | cf.osb.co |
    And I press "Create"
    Then I should be on the dashboard
    And I should see a list with 1 site 
    And there should be a "cf.osb.co" repo

  Scenario: I create a site with an existing template
    Given I am logged in as an admin user
    And a template repo exists
    When I go to the new site page
    And I fill in site form with:
      | name | url       |
      | CF   | cf.osb.co |
    And I press "Create"
    Then I should be on the dashboard
    And I should see a list with 1 site 
    And there should be a "cf.osb.co" repo with template setup

  Scenario: I delete a site
    Given I have the following sites:
      | name   |  url      |
      | CF     | cf.osb.co |
      | Bubble | bub.osb.co|
    And I am logged in as an admin user
    When I go to the dashboard
    Then I should see a list with 2 sites
    When I click on "Delete"
    Then I should see a list with 1 site
    And there should be not be a "cf.osb.co" repo
