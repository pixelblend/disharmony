# language: en
Feature: Page scraping
  In order to select available podcasts
  Disharmony must connect to the source site
  And select content that contains show information
  And create show entities

  Scenario: A post with no zip file
    When I scrape the no-zip page
    And I find the first post
    Then I should not create a show 
  
  Scenario: A post with multiple zip files
    When I scrape multiple-zip page
    And I find the first post
    Then I should create a show with multiple zip files
