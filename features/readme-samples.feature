@readme
Feature: README samples

  Scenario: Add a node to the graph
    Given an empty graph
    When executing query:
      """
      INSERT (p:Person {age: 25})
      """
    Then the result should be empty
    And the side effects should be:
      | +nodes | 1 |

  Scenario: Find a node with a specific label and property value
    Given the person-1 graph
    When executing query:
      """
      MATCH (p:Person) WHERE p.age = 25 RETURN p
      """
    Then the result should be in any order:
    | p |

  Scenario: [5] Conjunction is commutative on null
    Given an omitted graph
    When executing query:
      """
      FOR a IN [true, false, null]
      FOR b IN [true, false, null]
      FILTER WHERE a IS NULL OR b IS NULL
      RETURN a, b, ((a AND b) IS null) = ((b AND a) IS NULL) AS result
      """
    Then the result should be, in any order:
      | a     | b     | result |
      | true  | null  | true   |
      | false | null  | true   |
      | null  | true  | true   |
      | null  | false | true   |
      | null  | null  | true   |
    And no side effects


  Scenario: Insert node with invalid label, raises exceptions
    Given the graph created by executing:
          """
      CREATE GRAPH mygraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      INSERT (e:Employee {age: 25})
      """
    Then an exception condition should be raised: G2000

  Scenario: Match node with invalid label, raises exceptions
    Given the graph created by executing:
          """
      CREATE GRAPH mygraph {
        (Person :Person {lastname STRING, firstname STRING,joined DATE})
      }
      """
    When executing query:
      """
      MATCH (e:Employee) RETURN e
      """
    Then an exception condition should be raised: G2000

  Scenario Outline: [8] Fail on conjunction of at least one non-booleans
    Given the graph created using:
    """
    <query>
    """
    When executing query:
    """
    RETURN <a> AND <b>
    """
    Then an exception condition should be raised: 42000

    @GG01
    Examples:
      | query | a       | b       |
      | CREATE GRAPH test ANY | 123     | true    |
      | CREATE GRAPH test ANY | 123.4   | false   |
      | CREATE GRAPH test ANY | 'foo'   | {x: []} |
      | CREATE GRAPH test ANY | [true]  | [true]  |
      | CREATE GRAPH test ANY | {x: []} | [123]   |

    @GG02
    Examples:
      | query | a       | b       |
      | CREATE GRAPH test {()} | 123     | true    |
      | CREATE GRAPH test {()} | 123.4   | null    |
      | CREATE GRAPH test {()} | 'foo'   | {x: []} |
      | CREATE GRAPH test {()} | [true]  | [true]  |
      | CREATE GRAPH test {()} | {x: []} | [123]   |

  Scenario Outline: [1] Insert a node with a label and property
    Given the graph created using:
      """
      <query>
      """
    And having executed:
      """
      INSERT (p:Person { age: 30 })
      """
    When executing query:
      """
      MATCH (p:Person) WHERE p.age > 20 RETURN COUNT(p)
      """
    Then the result should be, in any order:
      | 1 |

    @GG01
    Scenarios: Graph with open graph type
      | query |
      | CREATE GRAPH test ANY |

    @GG02
    Scenarios: Graph with closed graph type
      | query |
      | CREATE GRAPH test {(Person :Person {age INT})} |

  @core
  Scenario: Untagged
    Given the graph created using:
      """
      CREATE GRAPH test ANY
      """
    Then the result should be empty

  Scenario: Find a node with a specific label and property value
    Given the person-1 graph
    When executing query:
    """
    MATCH (p:Person) WHERE p.age = 25 RETURN p
    """
    Then the result should be in any order:
      | p                                          |
      | (:Person { name: "Bill Jones", age: 25 })  |
      | (:Person { name: "Anne Rogers", age: 25 }) |

  Scenario: Add a node to the graph
    Given an empty graph named my-graph
    When executing query:
    """
    USE my-graph INSERT (p:Person {age: 25})
    """
    Then the result should be empty
    And the side effects should be:
      | +nodes | 1 |
      | +properties | 1 |
      | +labels | 1 |

  Scenario: [5] Verify the nodes of a given node type Given the empty-graph-1 graph
    And after having executed the query
    """
      INSERT (:Person{Name:'Aretha'})
    """
    When executing the query:
    """
      MATCH (a:Person) RETURN a.Name
    """
  Then the result should be, in any order:
    | a.Name |
    | "Aretha" |
  And there are no side effects

  Scenario: [3] Create nodes of a given node type
    Given the empty-graph-1 graph
    When executing the program:
      """
      INSERT (:Person{Name:'Aretha'}),(:Person{Name:'Scott'})
      """
    Then the result should be empty
    And the side effects should be:
      | +nodes      | 2 |
      | +node-types | 1 |
      | +properties | 1 |
      | +labels     | 1 |

  Scenario: [1] Create a node of a given node type
    Given the empty-graph-1 graph
    When executing data-modifying statement:
      """
      INSERT (:Person{Name:'Aretha'})
      """
    Then the result should be empty
    And the side effects should be:
      | +nodes      | 1 |
      | +node-types | 1 |
      | +properties | 1 |
      | +labels     | 1 |
