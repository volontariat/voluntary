Feature: Manage organizations
  In order to categorize projects
  An master
  wants to manage organizations
  
  Background:
  
    Given a user named "user"
    And I log in as "user"

  Scenario: Edit organization
    Given an organization named "organization 1" assigned to me
    When I go to the edit organization page
    And I fill in "Name" with "organization 2"
    And I press "Update Organization"
    Then I should see "Update successful"
    And I should see "organization 2"
    
  @javascript
  Scenario: Delete organization
    Given 2 organizations assigned to me
    When I delete the 1st "organization"
    Then I should see "Resource destroyed successfully"
    Then I should see the following table:
      |Name | |
      |organization 2 | Actions | 
      
  Scenario: Cannot delete organization which is not assigned to me
    Given an organization named "organization 1"
    And I am on the organizations page
    Then I should not see "Destroy"