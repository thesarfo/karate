Feature: wallets api tests

  Background:
    * url 'http://localhost:5019/api/v1/Wallet'

  Scenario: get all wallets
    Given path ''
    When method get
    Then status 200

    And match response.message == 'Wallets retrieved successfully.'
    And match response.content.meta ==
      """
      {
        "currentPage": 1,
        "totalPages": #number,
        "pageSize": 10,
        "totalCount": #number,
        "hasPreviousPage": false,
        "hasNextPage": #boolean
      }
      """
    And match response.content.data == '#[]'

  Scenario: get a single wallet by id
    Given path '98a857a7-5ae8-4a9e-84ee-2faa70bb0eb7'
    When method get
    Then status 200

    And match response.content.id == '98a857a7-5ae8-4a9e-84ee-2faa70bb0eb7'

  Scenario: create and verify new wallet
    * def wallet =
      """
      {
        "name": "Test Walletzzz",
        "accountNumber": "0548128272",
        "accountScheme": "MTN",
        "type": "Momo",
        "owner": "0544777111"
      }
      """

    Given path ''
    And request wallet
    When method post
    Then status 201

    And match response ==
      """
      {
        "content": {
          "id": "#notnull",
          "name": "Test Walletzzz",
          "accountNumber": "0548128272",
          "accountScheme": "mtn",
          "type": "momo",
          "owner": "0544777111",
          "createdAt": "#notnull"
        },
        "message": "Wallet added successfully."
      }
      """
