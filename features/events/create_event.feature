Feature: Manage Events
  In order to use the website to make events
  A signed in user
  Should be able to Manage their Event

    Scenario: User creates an event
      Given I am logged in
      When I create an event
      Then I should be a user of the event
        And I should an owner of the event

    Scenario: User adds a friend to an event
      Given I exist as a user
        And I am logged in
        And I create an event
        And My friend exists as a user
      When I add a friend to the event
      Then He should be a user of the event
      And He should not be an owner of the event

    Scenario: User goes to home page
      Given I am logged in
      When I visit my home page
      Then I should see a list of all my events

    Scenario: User goes to an event page
      Given I am logged in
      When I visit my home page
        And I visit the first event
      Then I should see the first event details
