Feature: Second Feature File for Todos
  Background:
      * url apiUrl

  Scenario: Update and delete todos

    * def taskName = 'MyFirstTask'

    # Create a single todo
    Given request { "title": '#(taskName)', "complete": false }
    When method post
    Then status 200
    And match response == { id: '#string', title: '#(taskName)', complete: false }
    * def id = response.id

    # Update a todo
    Given path id
    And request { title: '#(taskName)', complete: true }
    When method put
    Then status 200
    And match response.complete == true

    # Delete a todo
    Given path id
    When method delete
    Then status 200