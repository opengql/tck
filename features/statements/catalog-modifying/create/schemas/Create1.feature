
#encoding: utf-8

@GC01
Feature: Create1 - Creating schemas

  Scenario: [1] Create a schema at the root
    Given an empty catalog
    When executing the program:
      """
      CREATE SCHEMA /myschema
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 1 |

  Scenario: [2] Create a schema, in a directory
    Given an empty catalog
    When executing the program:
      """
      CREATE SCHEMA /foo/myschema
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 1 |
      | +directories | 1 |

  Scenario: [3] Raise error condition creating a schema that already exists
    Given an empty catalog
    And having executed the program:
      """
      CREATE SCHEMA /myschema
      """
    When executing the program:
      """
      CREATE SCHEMA /myschema
      """
    Then an exception condition should be raised: 42000

  Scenario: [4] Raise error condition creating a schema whose name identifies a directory
    Given an empty catalog
    And having executed the program:
      """
      CREATE SCHEMA /foo/myschema
      """
    When executing the program:
      """
      CREATE SCHEMA /foo
      """
    Then an exception condition should be raised: 42000

  Scenario: [5] Raise error condition creating a schema whose name identifies a graph
    Given an empty catalog
    And having executed the program:
      """
      CREATE SCHEMA /foo
      CREATE GRAPH /foo/mygraph ANY
      """
    When executing the program:
      """
      CREATE SCHEMA /foo/mygraph
      """
    Then an exception condition should be raised: 42000

  Scenario: [6] Raise error condition creating a schema whose name identifies a graph type
    Given an empty catalog
    And having executed the program:
      """
      CREATE SCHEMA /foo
      CREATE GRAPH TYPE /foo/mygraphtype {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing the program:
      """
      CREATE SCHEMA /foo/mygraphtype
      """
    Then an exception condition should be raised: 42000

  @GC02
  Scenario: [7] Create a schema, if not exists
    Given an empty catalog
    And having executed the program:
      """
      CREATE SCHEMA /foo/myschema
      """
    When executing the program:
      """
      CREATE SCHEMA /foo/myschema
      """
    Then the result should be empty
    And the side effects should be:
      | +schemas | 0 |

  Scenario: [8] Create schema statement fails from read-only transaction
    Given an empty catalog
    When executing the program:
      """
      START TRANSACTION READ ONLY
        CREATE SCHEMA /foo
      COMMIT
      """
    Then an exception condition should be raised: 25G03

  Scenario: [9] Create schema statement fails, if combined with other statements
    Given an empty catalog
    When executing the program:
      """
      CREATE SCHEMA /foo
        NEXT CREATE SCHEMA /fee
      """
    Then an exception condition should be raised: 42000
