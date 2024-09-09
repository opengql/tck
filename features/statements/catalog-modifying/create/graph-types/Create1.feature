#encoding: utf-8

@GG02, @GG23
Feature: Create1 - Creating single node types with optional key label sets

  Scenario: [1] Create a single node type with one label
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person)
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |

  Scenario: [2] Create a single node type with one label
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (p:Person)
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |

  Scenario: [3] Create a single node type with one label, and two properties
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person {name STRING NOT NULL, age INT})
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |

  Scenario: [4] Create a single node type with three labels, and three properties
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person&Student&Happy {name STRING NOT NULL, age INT, studentID STRING})
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |

  Scenario: [5] Create a single node type with three labels, and three properties
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (p:Person&Student&Happy {name STRING NOT NULL, age INT, studentID STRING})
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |

  Scenario: [6] Creating a single node type with duplicate property names fails
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (p:Person&Student&Happy {name STRING NOT NULL, age INT, studentID STRING})
      }
      """
    Then an exception condition should be raised: 42000

  Scenario: [7] Creating a single node type with the number of labels less than the minimum cardinality of node label sets fails
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        ($(randomLabelSet(minNodeLabels-1)) {name STRING, age INT})
      }
      """
    Then an exception condition should be raised: 22G0N

  Scenario: [8] Creating a single node type with the number of labels greater than the maximum cardinality of node label sets fails
    Given an empty catalog
    And a randomly generated label set of size
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        ($(randomLabelSet(maxNodeLabels+1)) {name STRING, age INT})
      }
      """
    Then an exception condition should be raised: 22G0P

