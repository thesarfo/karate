# Karate API Automation Testing – Quick Reference

This repository is meant to be a personal walkthrough and reference guide for API automation testing using [Karate](https://github.com/karatelabs/karate).


## Making A First Request

Karate tests are structured similarly to unit tests with JUnit and follow the standard `Given-When-Then` syntax.

However, instead of Java assertions, Karate provides its own domain-specific language (DSL) for writing assertions.

### Sample Test: Get All Wallets

```gherkin
Feature: Wallets API Tests

Scenario: Get all wallets
  Given url 'http://localhost:5019/api/v1/Wallet'
  When method get
  Then status 200
```


## Running Tests

You can run Karate tests using Maven:

```bash
mvn test                      # Run all tests
mvn test -Dtest=WalletsTest  # Run a specific test class
```

---

## Response Matching

When you make an API call, the response is stored in a built-in variable called `response`. You can assert its structure and values like this:

### Basic Structure Assertion

```gherkin
Then status 200
And match response == { "id": "#number", "name": "#string" }
```

Karate supports a variety of built-in data types for flexible matching:

| Type        | Description      |
| ----------- | ---------------- |
| `#string`   | Any string       |
| `#number`   | Any number       |
| `#boolean`  | true / false     |
| `#date`     | Date string      |
| `#time`     | Time string      |
| `#datetime` | DateTime string  |
| `#array`    | Any array        |
| `#object`   | Any object       |
| `#null`     | Must be null     |
| `#notnull`  | Must not be null |

### Example: Response Matching

Given a response like:

```json
{
  "content": {
    "id": "5138-...",
    "name": "Test Walletz",
    "accountNumber": "0548223427",
    "accountScheme": "mtn",
    "type": "momo",
    "owner": "0540918298",
    "createdAt": "2025-05-10T07:47:45.1350753Z"
  },
  "message": "Wallet added successfully."
}
```

You can assert it like so:

```gherkin
And match response.content ==
  """
  {
    "id": "5138-...",
    "name": "Test Walletz",
    "accountNumber": "0548223427",
    "accountScheme": "mtn",
    "type": "momo",
    "owner": "0540918298",
    "createdAt": "2025-05-10T07:47:45.1350753Z"
  }
  """
```

Or use flexible types:

```gherkin
And match response.content ==
  """
  {
    "id": "#notnull",
    "name": "#string",
    "accountNumber": "#string",
    "accountScheme": "#string",
    "type": "#string",
    "owner": "#string",
    "createdAt": "#datetime"
  }
  """
```



## Array Matching

Karate provides syntactic sugar for matching arrays:

```gherkin
And match response.content.data == '#[]'      # any array
And match response.content.data == '#[3]'     # at least 3 items
And match response.content.data == '##[3]'    # exactly 3 items
```

## Request Templates

Use request templates to keep your tests DRY. You can define a request body as a variable and reuse it.

```gherkin
* def wallet =
  """
  {
    "name": "Test Walletz",
    "accountNumber": "0548223427",
    "accountScheme": "mtn",
    "type": "momo",
    "owner": "0540918298"
  }
  """

Given path ''
And request wallet
When method post
Then status 201
```

To avoid repeating the base URL in each scenario, define it in the `Background` section:

```gherkin
Background:
  * url 'http://localhost:5019/api/v1/Wallet'
```



## Example Suite

```gherkin
Feature: Wallets API Tests

  Background:
    * url 'http://localhost:5019/api/v1/Wallet'

  Scenario: Get all wallets
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

  Scenario: Create and verify new wallet
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
```
