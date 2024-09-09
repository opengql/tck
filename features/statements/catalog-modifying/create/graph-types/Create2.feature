#encoding: utf-8

@GG02, @GG21
Feature: Create2 - Creating single node types with explicit element type key label set

  @MinNodeLabelsZero, @MinNodeTypeKeyLabelsZero
  Scenario: [1] Create a single node type key label set, cardinality 0, node type labels, cardinality 0
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        ( => )
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |

  @MinNodeTypeKeyLabelsZero
  Scenario: [2] Create a single node type key label set, cardinality 0, node type labels, cardinality 1
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        ( => :Student )
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |

  @MinNodeLabelsZero
  Scenario: [3] Create a single node type key label set, cardinality 1, node type labels, cardinality 0
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person => )
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |

  Scenario: [4] Create a single node type key label set, cardinality 1, node type labels, cardinality 1
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person => :Student )
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |

  @MaxNodeLabelsGTOne
  Scenario: [5] Create a single node type key label set, cardinality 1, node type labels, cardinality 2
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person => :Student&Happy )
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |

  @MaxNodeLabelsGTOne, @MaxNodeTypeKeyLabelsGTOne
  Scenario: [6] Create a single node type key label set, cardinality 2, node type labels, cardinality 2
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person&Student => :Happy&Nerd )
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |

  @MaxNodeLabelsGTOne, @MaxNodeTypeKeyLabelsGTOne
  Scenario: [7] Create a single node type key label set, cardinality 2, node type labels, cardinality 2, properties 3
    Given an empty catalog
    When executing the program:
      """
      CREATE GRAPH TYPE mygraphtype {
        (:Person&Student => :Happy&Nerd {name STRING NOT NULL, age INT, studentID STRING})
      }
      """
    Then the result should be empty
    And the side effects should be:
      | +graph-types | 1 |
      | +node-types | 1 |
      | +node-type-keys | 1 |
