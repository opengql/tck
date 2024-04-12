Feature: Test1 - Integer expressions

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
