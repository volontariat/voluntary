Feature: Manage areas
  In order to categorize projects
  An user
  wants to add an area
  
  Background:
       
    Given a user named "user"
    And I log in as "user"
  
  Scenario: Register new area
    Given I am on the new area page
    When I fill in "Name" with "name 1"
    And I press "Create"
    Then I should see "Creation successful"
    And I should see "name 1"

  Scenario: Edit area
    Then I can't edit areas

  Scenario: Delete area
    Then I can't delete areas
    
  Scenario: Nest area
    Given an area named "General"
    When I am on the area page
    And I follow "New Area"
    And I fill in "Name" with "Child"
    And I press "Create"
    Then I should see "Creation successful"
    And I should see "Areas > General > Child"