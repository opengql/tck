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

  Scenario: [5] Raise error condition creating a schema whose name identifies a graph
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo
      CREATE GRAPH /foo/mygraph ANY
      """
    When executing query:
      """
      CREATE SCHEMA /foo/mygraph
      """
    Then an exception condition should be raised: 42000

  Scenario: [6] Raise error condition creating a schema whose name identifies a graph type
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo
      CREATE GRAPH TYPE /foo/mygraphtype {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      CREATE SCHEMA /foo/mygraphtype
      """
    Then an exception condition should be raised: 42000
