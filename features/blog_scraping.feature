# language: en
Feature: Blog Scraping
  In order to select shows to download
  I want to see a list of the latest shows
  And display track list information
  And confirm the location of the show file
  And download the show
  And convert the show into iTunes-friendly podcast format

  Scenario: Entries List
    Given I have not downloaded the recent show
    When I request the current show
    Then I should see the latest show
    And it should be downloaded
    And it should be tagged correctly
    And available in the correct location

#  Scenario: Show Downloads
#    Given I have a list of recent shows
#    When I download the latest show
#    Then it should save the archive file
#    And extract the mp3
#    And add Podcast ID3 tags
