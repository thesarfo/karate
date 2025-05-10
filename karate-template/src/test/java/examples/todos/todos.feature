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

