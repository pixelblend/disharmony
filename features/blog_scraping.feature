# language: en
Feature: Blog Scraping
  In order to select shows to download
  I want to see a list of the latest shows
  And display track list information
  And confirm the location of the show file
  And download the show
  And convert the show into iTunes-friendly podcast format

  Scenario: Latest Show
    Given I have not downloaded any shows
    When I request the latest show
    Then I should see the latest show
    And it should be downloaded
    And it should be tagged correctly
    And available in the correct location
    And it should not be available to download again

  Scenario: Most Recent Shows
    Given I have the latest show
    When I request the recent shows
    Then I should only download the remaining 4 shows
