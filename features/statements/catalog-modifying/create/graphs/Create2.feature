#encoding: utf-8

@GC04
Feature: Create1 - Creating graphs

  @GG01
  Scenario: [1] Create an open graph
    Given an empty catalog
    When executing query:
      """
      CREATE GRAPH mygraph ANY
      """
    Then the result should be empty
    And the side effects should be:
      | +graphs | 1 |

  @GG02
  Scenario: [2] Create an closed graph from graph type reference
    Given an empty catalog
    And having executed:
      """
      CREATE GRAPH TYPE mygraphtype {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      CREATE GRAPH mygraph mygraphtype
      """
    Then the result should be empty
    And the side effects should be:
      | +graphs | 1 |

  @GG02, @GG03
  Scenario: [3] Create an closed graph from an inline graph type specification
    Given an empty catalog
    When executing query:
      """
      CREATE GRAPH mygraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graphs | 1 |

  @GG02, @GG04
  Scenario: [4] Create an closed graph like another graph
    Given an empty catalog
    And having executed:
      """
      CREATE GRAPH /mysrcgraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      CREATE GRAPH /mygraph LIKE /mysrcgraph
      """
    Then result should be empty
    And these graphs should have equivalent graph types:
      | /mysrcgraph | /mygraph |
    And the side effects should be:
      | +graphs | 1 |

  @GG01, @GG05
  Scenario: [5] Create an open graph, copying an existing open graph
    Given an empty catalog
    And having executed:
      """
      CREATE GRAPH mysrcgraph ANY
      """
    When executing query:
      """
      CREATE GRAPH mygraph ANY AS COPY OF mysrcgraph
      """
    Then the result should be empty
    And these graphs should be equivalent:
      | mysrcgraph | mygraph |
    And the side effects should be:
      | +graphs | 1 |

  @GG02, @GG03, @GG05
  Scenario: [6] Create an closed graph, by copying an existing closed graph
    Given an empty catalog
    And having executed:
      """
      CREATE GRAPH mysrcgraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      CREATE GRAPH mygraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      } AS COPY OF mysrcgraph
      """
    Then the result should be empty
    And these graphs and their types should be equivalent:
      | mysrcgraph | mygraph |
    And the side effects should be:
      | +graphs | 1 |

  @GG02, @GG03, @GG05
  Scenario: [7] Creating a closed graph, by copying an existing closed graph with different type, fails
    Given an empty catalog
    And having executed:
      """
      CREATE GRAPH mysrcgraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      CREATE GRAPH mygraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE}),
        (Employer :Employer {name STRING})
      } AS COPY OF mysrcgraph
      """
    Then an exception condition should be raised: G2000

  @GG01, @GG02, @GG03, @GG05
  Scenario: [8] Create an open graph, by copying an existing closed graph
    Given an empty catalog
    And having executed:
      """
      CREATE GRAPH mysrcgraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      CREATE GRAPH ANY AS COPY OF mysrcgraph
      """
    Then the result should be empty
    And these graphs and their types should be equivalent:
      | mysrcgraph | mygraph |
    And the side effects should be:
      | +graphs | 1 |
