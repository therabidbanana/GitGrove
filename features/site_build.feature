Feature: Site Builder
  In order to quickly build sites
  As a developer
  I should be able to preview a build of the site after git push

  Background:
    Given I have a cleaned out sites directory
    And I am logged in as a regular user

  Scenario: I push changes to a site
    Given I have a working site template
    And I have the following sites:
      | name   |  url      |
      | CF     | cf        |
    And I have a working clone of "cf"
    When I edit the index of "cf" to have markdown body
      """
      Foobar
      ------
      """
    And I commit and push changes to "cf"
    And I visit the preview site for "cf"
    Then the page should include "Foobar" as a header
