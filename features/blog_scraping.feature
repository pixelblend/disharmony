# language: en
Feature: Blog Scraping
  In order to select shows to download
  As a user
  I want to see a list of the latest shows
  And display track list information
  And confirm the location of the show file
  And download the show
  And convert the show into iTunes-friendly podcast format

  Scenario: Entries List
    Given I have not downloaded any recent shows
    When I request a list of shows
    Then I should see the latest 10 shows
   
  Scenario: Show Downloads
    Given I have a list of recent shows
    When I download the latest show
    Then it should save the archive file
    And extract the mp3
    And add Podcast ID3 tags