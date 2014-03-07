Feature: Read organizations
  In order to offer place for organizations
  A guest
  wants to try managing organizations
  
  Scenario: Register new organization
    Given I am on the new organization page
    Then I should see "Access denied"

  Scenario: Edit organization
    Given an organization named "area 1"
    When I go to the edit organization page
    Then I should see "Access denied"

  @javascript
  Scenario: Delete organization
    Given an organization named "organization 1" 
    When I am on the organization page
    Then I should not see "Actions"
