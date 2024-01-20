
#encoding: utf-8

Feature: Create1 - Creating schemas

  Scenario: [1] Create a schema at the root
    Given any catalog
    When executing query:
      """
      CREATE SCHEMA IF NOT EXISTS /movies
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 1 |

  Scenario: [2] Create a schema
    Given any catalog
    When executing query:
      """
      CREATE SCHEMA IF NOT EXISTS /my_schemas/movies
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 1 |

  Scenario: [3] Do not create a schema that already exists
    Given the catalog-1 catalog
    When executing query:
      """
      CREATE SCHEMA IF NOT EXISTS /my_schemas/movies
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 0 |

  Scenario: [4] Fail when creating a schema that already exists
    Given the catalog-1 catalog
    When executing query:
      """
      CREATE SCHEMA /my_schemas/movies
      """
    Then an exception condition should be raised: 42000

  Scenario: [5] Fail when creating a schema with the same path as an existing directory
    Given the catalog-1 catalog
    When executing query:
      """
      CREATE SCHEMA /my_schemas
      """
    Then an exception condition should be raised: 42000

  Scenario: [5] Fail when creating a schema with the same path as an existing graph
    Given the catalog-2 catalog
    When executing query:
      """
      CREATE SCHEMA /movies
      """
    Then an exception condition should be raised: 42000
