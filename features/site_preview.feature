Feature: Site Preview
  Background:
    Given I have a working site template
    And I have the following sites:
      | name   |  url      |
      | CF     | cf        |
  
  Scenario: I am not logged in but try to preview
    When I visit the preview site for "cf"
    Then I should be on the signin page
