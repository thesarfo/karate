Feature: Karate Basic Todos

  Background:
    * url apiUrl

  Scenario: Basic todo flow
    * def taskName = 'FirstTask'



    # Get a single todo
    Given path id
    When method get
    Then status 200
    And match response == {id: '#(id)', title: '#(taskName)', complete: #(status) }

    # Create a second todo
    * def todo =
    """
    {
        "title": "Second",
        "complete": false
    }
    """

    Given request todo
    And header Content-Type = 'application/json'
    When method post
    Then status 200
    And match response.title == 'Second'

    # Get all todos
    When method get
    Then status 200
    * def firstTask = response[0]
    * match firstTask.title == taskName
    * match firstTask.complete == false

    # check all response objects
    * match each response contains { complete: '#boolean' }

    # Clear all tasks
    Given url 'http://localhost:8080/api/reset'
    When method get
    Then status 200
    And match response == { deleted: '#number' }