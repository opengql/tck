# TCK for GQL (github.com/opengql/tck)

## Introduction
A Language-independent Technology Compatibility Kit (TCK) for GQL.

The TCK for GQL, hereafter referred to as the TCK, is derived from the [openCypher TCK](https://opencypher.org/resources/) since the two languages share many language features. Some text in this document was taken from the [openCypher README](https://github.com/opencypher/openCypher/blob/master/tck/README.adoc. In addition, source files and components contained in this TCK are modified from the originals in the openCypher TCK. See [NOTICE](NOTICE.md) for details.

The TCK is built using [Cucumber](https://cucumber.io/), open source technology for specifying and executing a set of compatibility tests.

Cucumber defines a textual format called [Gherkin](https://cucumber.io/docs/gherkin/) for specifying compatibility tests. It also provides a library and a framework for interpreting Gherkin tests and implementing the scaffolding to execute a set of compatibility tests, against a given implementation. Implementations of the library and framework are available for the most popular programming languages.

An individual compatibility test in Gherkin is known as a _Scenario_, or _Example_. The term Scenario will be used throughout this document. A set of related scenarios are organized into what Gherkin calls a _Feature_. In the TCK, each Feature and its Scenarios are stored in an individual text file.

A complete set of compatibility tests for a given specification is referred to as a Technology Compatibility Kit (TCK).

This repository is designed to be included as a submodule from other repositories. The parent repository is responsible for providing TCK scaffolding and runtime (using the Cucumber library and framework) to execute the TCK against a GQL-implementation.

[GQL Parser for Go](https://github.com/mburbidg/gql-parser) is an example of a repository that uses the TCK by including this repository as a submodule. That repository uses the Go version of [Cucumber](https://cucumber.io/docs/installation/golang/) as the TCK runtime environment to run the TCK. It also provides other infrastructure such as Makefile, etc. to run the TCK.

Both contributors and consumers of the TCK need to understand the goals and limitations of the TCK. This document describes the principles used in the development of TCK Features and Scenarios. It describes what the TCK is, and what it is not.

### Goals and limitations
Testing a production database is a monumental task. It requires a variety of testing strategies, including but not limited to: unit testing, smoke testing, integration testing, longevity testing, performance testing, end-to-end testing, disaster-recovery testing etc. The TCK is not designed or intended to address most of these testing needs.

The primary purpose and goal of the TCK for GQL is to functionally validate that a GQL-implementation conforms to the GQL Specification. This is an important, but limited aspect of the overall testing strategy for a production grade GQL-implementation.

This narrowly scoped purpose and goal has implications on how the TCK Features and Scenarios are designed and implemented and the kind of sample data that is used in the TCK. These principles of design and development are described below.

## Architecture

Figure 1 illustates the relationship between a GQL-implementation and the TCK Runtime and TCK.

![Diagram](diagrams/images/TCK%20Diagram.jpg)

The GQL-implementation is responsible for implementing the TCK Runtime. The TCK Runtime includes the Cucumber library to assist in the implementation of the runtime. The TCK Runtime also includes the contents of this repository, containing the TCK Features and Scenarios, and associated test data. i.e. the compatibility tests.

The TCK Runtime is considered part of the GQL-implementation. It submits requests to the GQL-server by public or optionally private channels. It might also submit requests to the GQL-server via a GQL-client.

The TCK Runtime provides an implementation-dependent mechanism for executing TCK compatibility tests. It does this with cooperation with and support of the Cucumber library. The mechanism differs somewhat depending on the implementation language.

## Organization

At the top level, the TCK contains Cucumber features and scenarios and sample data used by the scenarios. All features and scenarios are organized under the directory _features_.

### Sample data
Sample data is organized under the directory _data_. Sample data can consist of catalogs, graphs and graph-types. The following diagram illustrates this organization.
```
└── tck
    ├── features
    └── data
        ├── catalogs
        │   ├── catalog-1.gql
        │   └── catalog-2.gql
        ├── graph-types
        │   └── graph-type-1.gql
        └── graphs
            ├── graph-1.gql
            ├── graph-2.gql
            └── graph-3.gql
```

### Features and scenarios

Features and Scenarios are organized into multiple files. These files in turn are organized into a directory hierarchy, rooted by the _features_ directory. The Cucumber runtime provides the capability to execute the scenarios in individual files or in all the scenarios in all the files in an individual directory, or recursively all the scenarios in all the files in a directory hierarchy.

Features and Scenarios of the TCK are organized into a directory structure and naming convention that mirrors the overall structure of the GQL Specification. This enables the execution of scenarios for a subset of the language. e.g. execute all catalog-modifying statement scenarios, or execute all graph creation statement scenarios.

Some aspects of the GQL Language are cross-cutting. For example `<value expressions>`. The directory structure also reflects the large cross-cutting aspects of the language. As a result, consumers can execute scenarios focused on one of these cross-cutting features. e.g. execute all `<graph expression>` scenarios or execute all `<value expression>` scenarios.

This overall directory structure follows the general pattern of the [openCypher TCK](https://github.com/opencypher/openCypher/tree/master/tck), but has been adjusted to reflect the structure and additional aspects of the GQL Language.

The names of directories and files reflect the names used in the GQL Specification. This is illustrated by the following partial, abbreviated example. 

```
└── features
    ├── commands
    │   ├── session
    │   └── transaction 
    ├── statements
    │   ├── catalog-modifying
    │   │   ├── create
    │   │   │   ├── schema1.feature
    │   │   │   └── graph1.feature
    │   │   └── drop
    │   ├── data-modifying
    │   └── query
    └── expressions
            ├── value
            └── object
                ├── graph
                │   ├── object primary1.feature
                │   ├── graph reference1.feature
                │   ├── object name or binding variable1.feature
                │   └── current graph1.feature
                └── binding table    
```
As shown by this example, all scenarios for all statements are organized under a directory named _statements_. Scenarios for cross-cutting features of GQL such as expressions are organized under a directory named _expressions_.

At each level in the hierarchy a judgement is made whether to organize scenarios in files, or to partition them further into subdirectories. The intention is that the directory structure of the TCK, generally reflects the structure of the grammar in the specification. But it does not follow it exactly and is not as fine-grained as the structure in the specification.

### Tagging

The GQL Specification defines a set of minimal requirements that must be met by a GQL-implementation to claim _Minimum conformance_. It also defines a set of optional features, one or more of which, may be implemented by a GQL-implementation.

The TCK contains scenarios that validate minimum conformance, and scenarios that validate conformance to each of the optional features defined by the specification.

Optional features are generally cross-cutting features that do not easily fit into the hierarchy defined in the previous section.

Implementers need the ability to execute the scenarios that validate minimum conformance and the subset of scenarios that validate the optional features implemented by their GQL-implementation. The TCK uses [Gherkin tags](https://cucumber.io/docs/cucumber/api/?lang=java#tags) to provide this capability.

Each optional GQL feature is assigned a four character Feature ID in the Specification.These Feature IDs are used to tag Features and/or Scenarios to indicate that a given Feature and/or Scenario validates conformance to the corresponding GQL feature.

Note that when a Gherkin Feature is tagged, each Scenario in the Feature inherits that tag.

The following feature and its scenarios for the CREATE GRAPH statement illustrate how tags are used in the TCK to validate optional features. The body of each scenario has been removed for brevity.

```
@GC04
Feature: Create1 - Creating graphs

  @GG01
  Scenario: [1] Create an open graph

  @GG02
  Scenario: [2] Create a closed graph from graph-type reference

  @GG02, @GG03
  Scenario: [3] Create a closed graph from an inline graph-type specification

  @GG02, @GG04
  Scenario: [4] Create an closed graph like another graph

  @GG01, @GG05
  Scenario: [5] Create an open graph, copying an existing open graph

  @GG02, @GG03, @GG05

  @GG02, @GG03, @GG05
  Scenario: [7] Creating a closed graph, by copying an existing closed graph with different type, fails

  @GG01, @GG02, @GG03, @GG05
```
The feature is tagged with _GC04 - Graph Management_ because all the scenarios in this feature validate various forms of the CREATE GRAPH statement, which is part of the optional _Graph Management_ feature. The scenarios in this feature should only be run against GQL-implementation claiming support for this optional feature.

_Scenario 1, Create an open graph_, validates the creation of a graph with an open graph-type. Creating a graph with an open graph-type is another optional feature (_GG01 - Graph with an open graph-type_). Therefore, this scenario is tagged with GG01, and inherits GC04 from its parent Feature.

_Scenario 3, Create a closed graph from an inline graph-type specification_, is tagged with two tags. _GG02 - Graph with a closed graph-type_, and _GG03 - Graph type inline specification_, because it validates a statement that depends on two optional features. It also inherits GC04 from its parent Feature.

According to the GQL Specification, a feature FEAT1 may imply another feature FEAT2. This means that if a GQL-implementation claims support for feature FEAT1, it shall also support feature FEAT2. This dependency can be seen in the example. According to the GQL Specification (see 24.7 Implied feature relationships), feature GG01 - Create open graph-type, implies GC04 - Graph Management. Thus, the scenario is tagged with both Feature IDs. Note: GC04 is "inherited" from the TCK Feature tag.

When executing scenarios a [_tag expression_](https://cucumber.io/docs/cucumber/api/?lang=java#tag-expressions) can be given to Cucumber runtime, that specifies the subset of scenarios that should be executed, based on the tag expression. Tag expressions are boolean logic expressions. The following tag expression will execute only scenarios that validate the _Graph Management_ optional feature.

```
@GC04
```

While this is a valid tag expression, it does not reflect the dependencies defined by the GQL Specification. If the GQL-implementation supports the creation of graphs with open graph-types, but not close graph-types this will result in unexpected scenario failure, because both subsets of scenarios will be executed.

The following illustrates a better tag expression because it adheres to the feature dependencies defined by the GQL Specification.

```
@GC04 and @GG01
```

When executing scenarios from the TCK, it is up to the consumers of the TCK, to construct tag expressions that reflect the feature dependencies defined by the GQL Specification, when executing TCK scenarios.

## Minimum conformance

Minimum conformance is defined by 24.2 Minimum conformance, in the GQL Specification. An abbreviated conformance statement is that an implementation meets minimum conformance if it supports the basic property graph data model defined by the specification, all syntax, not associated with an optional feature, one of Graph with open graph-type, or Graph with closed graph-type, conformance to the Unicode Standard, and support for the following data types: character strings, boolean, signed regular integers, and floats.

The challenging part of this definition from a TCK standpoint is the requirement that a GQL-implementation must support one of: 1) graph with open graph-type or 2) graph with closed graph-type. It can also support both.

From a TCK standpoint this means that the TCK must be able to:

1. Validate an implementation that only supports graphs with open graph-types
2. Validate an implementation that only supports graphs with closed graph-types
3. Validate an implementation that supports both

For the purposes of brevity, this document will use the term _untyped graph_ to refer to graphs with open graph-types and _typed graph_ to refer to graphs with closed graph-types.

A majority of the TCK scenarios are graph-type agnostic. Consider the following example.

```
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
```
This is a positive test, in that it is expected to succeed. It should execute successfully against any untyped graph. When run against a typed graph it can be made to succeed if the labels used in the query conform to the graph-type of the graph.

Here's another example.
```
Scenario: Add a node to the graph
  Given an empty graph
  When executing query:
    """
    INSERT (p:Person {age: 25})
    """
  Then the result should be empty
  And the side effects should be:
    | +nodes | 1 |
    | +properties | 1 |
    | +labels | 1 |
```
Again this is a positive test. It is expected to succeed. It should also execute successfully against any untyped graph. And when run against a typed graph with the appropriate graph-type it should succeed.

Neither of these tests are focused on validating type constraints. They are focused on MATCH and INSERT operations, and they should work against both untyped and typed graphs. Obviously there will be scenarios that are focused on type constraints. These tests for the most part will be negative tests and can only run against a typed graph.

Scenarios can be partitioned into the following three categories:

1. Scenarios that don't require a working graph
2. Scenarios that required a typed working graph
3. Scenarios that required a working graph, but are graph-type agnostic

### Scenarios that don't require a working graph

This includes scenarios that validate catalog-modifying (with one exception), LET, FOR, FILTER, and RETURN, statements. It also includes a large set of scenarios for validating expressions that can be expressed using LET, FOR, FILTER and RETURN. This is because none of these statements require working graphs.

For example, for following catalog-modifying statement scenario does not require a working graph.
```
Scenario: [1] Create a schema at the root
  Given an empty catalog
  When executing query:
    """
    CREATE SCHEMA /myschema
    """
  Then the result should be empty
  And the side effects should be:
    | +schemas | 1 |
```
And the following boolean expression scenario does not require a working graph.
```
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
```
From a TCK standpoint, these scenarios are straight forward to express, and require no additional support in the TCK Runtime.

### Scenarios that require a typed working graph

These scenarios validate the type constraints functionality defined by the specification. They are almost entirely negative tests, in that they are expected to fail with a _G2000_ exception condition.

The following MATCH scenario validates that an exception is raised when a label is used in a query that is not defined by the graph-type of a given graph.
```
@GG02
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
```
Similarly, the following INSERT scenario validates that an exception is raised when a label is used in a query that is not defined by the graph-type of a given graph. Note that these scenarios are tagged with the Feature ID for graphs with closed graph types.
```
@GG02
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
```
From a TCK standpoint, these scenarios are also straight forward to express, and require no additional support in the TCK Runtime.

### Scenarios that required a working graph, but are graph-type agnostic

These scenarios are not validating type constraints, and can be expressed in a graph-type agnostic form. They should succeed trivially against untyped graphs. They should also succeed against typed graphs, given they have the appropriate graph-type. But arranging for this requires support from the TCK Runtime and TCK.

The following example was given earlier, but is repeated here.
```
Scenario: Add a node to the graph
  Given an empty graph
  When executing query:
    """
    INSERT (p:Person {age: 25})
    """
  Then the result should be empty
  And the side effects should be:
    | +nodes | 1 |
    | +properties | 1 |
    | +labels | 1 |
```
This scenario should succeed against any untyped graph. It should also succeed against a typed graph with the following graph-type.
```
{
    (Person :Person {age INT})
}
```

To support graph-type agnostic scenarios the TCK Runtime provides the following mechanism for creating either an untyped graph or typed graph with the appropriate graph-type. The execution of scenarios can be parameterized to indicate whether to execute scenarios against untyped or typed graphs.

Graph-type agnostic scenarios must use graphs created from sample data. Each such graph is specified as a pair of text files in the _tck/data_ hierarchy. The first file, called the _populator_, contains a GQL-program to populate an empty graph with nodes and edges. The second file, called the _creator_, contains a GQL-program to create an empty typed graph. The graph-type should contain the appropriate definitions so that the scenarios intended to be executed against this graph will succeed, without type constraint violations.

The files should be siblings in the directory hierarchy and are associated by file naming convention. The base name of the creator must the base name of the populator appended with the suffix "-creator", as shown in the following example.
```
└── tck
    ├── features
    └── data
        └── graphs
            ├── person.gql
            ├── person-creator.gql
            ├── graph-1.gql
            └── graph-2.gql
```
These paired files are used by the TCK Runtime to create a populated untyped graph or a populated typed graph, with the appropriate graph-type.

Scenarios create graphs from sample data using the "**Given** the \<graph path\> graph" step as is illustrated in the following example.
```
Scenario: Add a node to the graph
  Given the graphs/person graph
  When executing query:
    """
    INSERT (p:Person {age: 25})
    """
  Then the result should be empty
  And the side effects should be:
    | +nodes | 1 |
    | +properties | 1 |
    | +labels | 1 |
```
When running against a GQL-implememtation that supports untyped graphs, the TCK Runtime executes the following program followed by the program contained in the populator file.
```
CREATE GRAPH person ANY
```

When running against a GQL-implementation that supports typed graphs, the TCK Runtime executes the program contained in the creator file, followed by the program contained in the populator file.

This mechanism provides the required capability to execute graph-type agnostic scenarios against both untyped and typed graphs, depending on what the GQL-implementation supports.

## Negative conformance

The TCK does not implement scenarios that attempt to validate negative conformance. e.g. There is no scenario that asserts failure when a statement that creates a graph with an open graph-type is executed against an implementation that does not support a graph with an open graph-type.

## Syntax

TCK scenarios are not focused on validating textual syntax. They do validate _Syntax Rules_ in the GQL Specification. e.g. variable scoping rules, etc.

The TCK scenarios do not validate optional, or synonymous syntax. e.g. NODE vs. VERTEX, or PROPERTY GRAPH vs. GRAPH. The TCK always uses NODE and EDGE. All optional tokens are dropped. e.g. The TCK always uses GRAPH, never PROPERTY GRAPH.

## Scenario design

Each scenario is independent, which implies that a scenario never relies on the result or side effects of a previous scenario. Independent scenarios follow the Cucumber guidelines ([Sharing state between scenarios](https://cucumber.io/docs/cucumber/state/?lang=java)) and allow for concurrent execution of scenarios.

Scenarios are small and focused, validating the smallest possible aspect of the GQL Specification.

With some exceptions, real world graphs and graph-types are not used by the TCK. Contrived graphs and graph-types are used to focus on a single feature of the GQL Language. For example, a graph-type with no property constraints is adequate to verify label set constraints.

### Combinatorial feature validation

Scenarios in the TCK have been designed to cover the entire GQL Language while limiting the number of scenarios due to the combinatorial effects of individual feature combinations.

For example, a graph expression is used by 8 other features in GQL. A graph expression has 4 alternative forms. At the very least this means if every form of graph expression is combined with every feature that uses a graph expression, there will be at least 32 scenarios needed to verify graph expressions and the features that interact with graph expressions.

To reduce the combinatorial effects of how features combine with each other, the strategy used by the TCK, is that the 8 features that use graph expressions will each have one scenario that test graph expressions, using exactly one form of graph expression. In addition, there is a set of scenarios for validating graph expressions. These scenarios will use one use case of graph scenarios and have a scenario for each graph expression form with that use case.

For example, _create graph statement_, and _session set command_ are two features that use graph expressions. The scenarios for create graph statement and session set command each contain a single scenario, that uses one form of a graph expression.

```
CREATE GRAPH mygraph LIKE CURRENT_GRAPH
SESSION SET GRAPH CURRENT_GRAPH
```

In addition, there are a set of scenarios for validating graph expressions. One use case is chosen against which all four graph expression alternatives are validated.

```
CREATE GRAPH mygraph LIKE VARIABLE othergraph           # like graph ref in binding variable
CREATE GRAPH mygraph LIKE othergraph                    # like catalog ref or graph ref in binding variable
CREATE GRAPH mygraph LIKE /othergraph                   # like catalog ref
CREATE GRAPH mygraph LIKE CURRENT_GRAPH                 # like current graph
```
In reality there are more variants because the first scenario has some additional variants. See `11.3 <object expression primary>`.

This approach reduces the number of scenarios from 32 to 12. This might not seem like a significant reduction but graph expressions combine in a limited manner compared to other features, such a `<value expressions>`.

## Principals and authorization

Since both Principals and their Privileges are implementation defined, there is little conformance validation that can be done in the TCK regarding them.

The TCK assumes that the TCK scaffolding executes all GQL-programs with a principal that has "super-user" privileges. Essentially no GQL-program executed by any scenario should fail for lack of privileges.

Certain steps provide the ability to set the _home schema_ or the _home graph_. Thus, the TCK also assumes that the same principal is used for the duration of a scenario.

## Transactions and Sessions

Todo

## Supported scenario steps

A Cucumber scenario consists of one or more steps. The steps begin with a keyword, and are customized for each TCK. The following steps are defined and used by the TCK for GQL.

This is a work in progress!

**Given** an empty catalog

**Given** the omitted graph

Sets the home graph of the scenario principal to _omitted_.

**Given** an empty graph

Sets the home graph of the scenario principal to a reference to an empty graph.

**Given** any graph

Sets the home graph of the scenario principal to a reference to any graph.

**Given** the \<graph name\> graph

Sets the home graph of the scenario principal to a reference to a graph created from \<graph name\>.

**Given** the graph created by executing the program: \<query\>

**And** having executed the program: \<GQL-program\>

**When** executing the program: \<GQL-program\>

**Then** the result should be empty

**Then** the result should be, in any order: \<table of results\>

**And** the side effects should be: \<table of metrics\>

**Then** an exception condition should be raised: \<GQLSTATUS\>

**And** these graphs should have equivalent graph-types: \<table of graph references\>

**And** these graphs should be equivalent: \<table of graph references\>

**And** these graphs and their types should be equivalent: \<table of graph references\>

## Side effects of executing a query

A GQL query that contains write clauses may have side effects that are persisted in the graph. A side effect is either the addition (denoted by +) or the removal (-) of one of the following objects:

| Object                  | Denoted by  |
|-------------------------|-------------|
| schema                  | schemas |
| graph                   | graphs |
| node                    | nodes |
| edge                    | edges |
| property                | properties |
| label                   | labels |
| label set               | label-sets |
| graph type              | graph-types |
| node type               | node-types |
| edge type               | edge-types |
| node type key label set | node-type-keys |
| edge type key label set | edge-type-keys |

An unspecified quantity implies that it is expected to be zero. If the side effects step reads And no side effects, this implies that all quantities are expected to be zero.

For 'negative' tests, where errors are expected (see GQL errors), it is implied that the graph suffers no side effects.

### Observability of side effects

Most side effects are observable from the point of view of a subsequent GQL query, but some are not. This does not mean that the side effect is insignificant, as it is almost always indirectly observable from the point of subsequent GQL queries.

Ultimately it is up to the TCK scaffolding and runtime to interact with the implementation to retrieve values for side effects. It may be through a private API or some other means.

Side effects that are only temporarily in effect during the execution of a query are not measured in these metrics.

For example, the query CREATE (n) DELETE n, which creates a node only to immediately delete it, may be correctly implemented as a no-op by a GQL-implementation, and a TCK scenario featuring it should not specify any side effects.

Concretely, observability of each metric is defined by one GQL query per metric, where possible, which will present the metric as the difference in returned records from executing the query before and after the query Q under test. These defining queries are listed as follows.

#### schemas
Observability of the _schemas_ metric:

GQL does not currently provide a query for discovering the number of schemas. However, many implementations will represent the Catalog as a system graph. A GQL query such as the following can return the number of schemas.

```
USE /system/catalog MATCH (s:Schema) RETURN COUNT(n)
```

#### graphs
Observability of the _graphs_ metric:

GQL does not currently provide a query for discovering the number of graphs. However, many implementations will represent the Catalog as a system graph. A GQL query such as the following can return the number of graphs.

```
USE /system/catalog MATCH (g:Graph) RETURN COUNT(g)
```

#### nodes
Observatibility of the _nodes_ metric:
```
MATCH (n) RETURN COUNT(n)
```

#### edges
Observability of the _edges_ metric:

```
MATCH ()-[e]->() RETURN COUNT(e)
```

#### properties
Observability of the _properties_ metric:

Todo

#### labels
Observability of the _labels_ metric:

Todo

#### graph-types
Observability of the _graph-types_ metric:

GQL does not currently provide a query for discovering the number of graph-types. However, many implementations will represent the Catalog as a system graph. A GQL query such as the following can return the number of graph-types.

```
USE /system/catalog MATCH (gt:GraphType) RETURN COUNT(gt)
```

#### node-types
Observability of the _node-types_ metric:

GQL does not currently provide a query for discovering the number of node types. However, many implementations will represent the Catalog as a system graph. A GQL query against that graph can return the number of node types.

```
USE /system/catalog MATCH (t:NodeType) RETURN COUNT(t)
```

#### edge-types
Observability of the _node-types_ metric:

GQL does not currently provide a query for discovering the number of edge types. However, many implementations will represent the Catalog as a system graph. A GQL query against that graph can return the number of edge types.

```
USE /system/catalog MATCH (t:EdgeType) RETURN COUNT(t)
```

#### node-type-keys
Observability of the _node-type-keys_ metric:

Todo

#### edge-type-keys
Observability of the _edge-type-keys_ metric:

Todo

## Scenario execution

There are three phases to the execution of a scenario. The initialization, execution, and cleanup.

During the initialization phase, the TCK Runtime is obligated to set the home graph of the principal used to execute the scenario to _omitted_.

During the execution phase, the scenario is executed. The scenario may create GQL-primary objects during its execution. The TCK Runtime must track each primary object created during the execution of a scenario. 

During the cleanup phase, the TCK Runtime must delete or drop and primary object created during the execution of the scenario.
