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
    Given path '98A857A7-5AE8-4A9E-84EE-2FAA70BB0EB7'
    When method get
    Then status 200

    And match response.content.id == '98A857A7-5AE8-4A9E-84EE-2FAA70BB0EB7'

  Scenario: create and verify new wallet
    * def wallet =
      """
      {
        "name": "Test Wallet",
        "accountNumber": "0548123457",
        "accountScheme": "MTN",
        "type": "Momo",
        "owner": "0540918498"
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
          "name": "Test Wallet",
          "accountNumber": "0548123457",
          "accountScheme": "mtn",
          "type": "momo",
          "owner": "0540918498",
          "createdAt": "#notnull"
        },
        "message": "Wallet added successfully."
      }
      """
