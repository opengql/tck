#encoding: utf-8

@GC01
Feature: Drop1 - Dropping schemas

  Scenario: [1] Drop a schema at the root
    Given catalog-1 catalog
    When executing query:
      """
      DROP SCHEMA /myschema
      """
    Then the result should be empty
    And the side effects should be:
      | -schemas | 1 |

  Scenario: [2] Raise error condition dropping a schema that doesn't exists
    Given catalog-1 catalog
    When executing query:
      """
      DROP SCHEMA /missing_schema
      """
    Then an exception condition should be raised: 42000

  Scenario: [3] Raise error condition dropping a schema whose name identifies a directory
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo/myschema
      """
    When executing query:
      """
      DROP SCHEMA /foo
      """
    Then an exception condition should be raised: 42000

  Scenario: [4] Raise error condition dropping a schema whose name identifies a graph
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo
      CREATE GRAPH /foo/mygraph ANY
      """
    When executing query:
      """
      DROP SCHEMA /foo/mygraph
      """
    Then an exception condition should be raised: 42000

  Scenario: [5] Raise error condition dropping a schema whose name identifies a graph type
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
      DROP SCHEMA /foo/mygraphtype
      """
    Then an exception condition should be raised: 42000

  Scenario: [6] Raise error condition dropping a non-empty schema
    Given an empty catalog
    And having executed:
      """
      CREATE SCHEMA /foo
      CREATE GRAPH /foo/mygraph ANY
      """
    When executing query:
      """
      DROP SCHEMA /foo
      """
    Then an exception condition should be raised: 42000

  @GC02
  Scenario: [7] Drop a schema, if exists
    Given an empty catalog
    When executing query:
      """
      DROP SCHEMA IF EXISTS /foo/myschema
      """
    Then the result should be empty
    And the side effects should be:
      | -schemas | 0 |
