# language: en
Feature: File Downloading
  In order to serve the podcast correctly
  Disharmony must download the show archive
  And select which file is the mp3 broadcast
  And extract in the correct location

  Scenario: Complex zip archive
    Given I download a show with a complex zip archive
    When I extract the zip archive
    Then I should have the mp3 broadcast
  
  Scenario: Multiple zip archives
    Given I download a show with a multiple zip archive
    When I extract the zip archive
    Then I should have a combined mp3 broadcast
  
  Scenario: Tricky zip archive
    Given I download a show with a tricky zip archive
    When I extract the zip archive
    Then I should have only the correct mp3 file left
