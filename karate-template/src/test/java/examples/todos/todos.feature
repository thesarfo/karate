Feature: Karate Basic Todos

  Background:
    * url 'http://localhost:8080/api/todos'

  Scenario: Get all todos
    Given url 'http://localhost:8080/api/todos'
    When method get
    Then status 200

  Scenario: Basic todo flow
    # Create a single todo
    Given request { "title": "First", "complete": false }
    When method post
    Then status 200
    And match response == { id: '#string', title: 'First', complete: false }

    * def id = response.id
    * def title = response.title
    * def status = response.complete
    * print "Value of ID: " + id

    # Get a single todo
    Given path id
    When method get
    Then status 200
    And match response == {id: '#(id)', title: '#(title)', complete: #(status) }

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
    * match firstTask.title == 'First'
    * match firstTask.complete == false