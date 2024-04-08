Feature: Test1 - Integer expressions

  Background:
    Given an empty graph

  Scenario: [1] Create a schema at the root
    Given an empty catalog
    When executing query:
      """
      CREATE SCHEMA /myschema
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 1 |
      | +directories | 0 |

  Scenario: [2] Create a schema, in a directory
    Given an empty catalog
    When executing query:
      """
      CREATE SCHEMA /foo/myschema
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 1 |
      | +directories | 1 |

  Scenario: [3] Raise error condition creating a schema that already exists
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /myschema
      """
    When executing query:
      """
      CREATE SCHEMA /myschema
      """
    Then an exception condition should be raised: 42000

  Scenario: [4] Raise error condition creating a schema whose name identifies a directory
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo/myschema
      """
    When executing query:
      """
      CREATE SCHEMA /foo
      """
    Then an exception condition should be raised: 42000
  Scenario: [7] Create a schema, if not exists
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo/myschema
      """
    When executing query:
      """
      CREATE SCHEMA /foo/myschema
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 0 |
      | +directories | 0 |
