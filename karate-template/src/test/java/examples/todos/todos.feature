Feature: Karate Basic Todos

  Background:
    * url 'http://localhost:8080/api/todos'

  Scenario: Get all todos
    Given url 'http://localhost:8080/api/todos'
    When method get
    Then status 200

  Scenario: Basic todo flow
    * def taskName = 'First'

    # Create a single todo
    Given request { "title": '#(taskName)', "complete": false }
    When method post
    Then status 200
    And match response == { id: '#string', title: '#(taskName)', complete: false }

    * def id = response.id
    * def title = response.title
    * def status = response.complete
    * print "Value of ID: " + id

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

    # Clear all tasks
    Given url 'http://localhost:8080/api/reset'
    When method get
    Then status 200
    And match response == { deleted: '#number' }