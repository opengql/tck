# TCK for GQL (gql-tck)
A Language-independent Technology Compatibilty Kit (TCK) for the GQL graph query language. The GQL TCK is derived from the [openCypher TCK](https://opencypher.org/resources/) as the two languages share many language features.

This repository is designed to be included as a submodule from other repositories. Such parent repositories are responsible for
providing TCK infrastructure and runtime to run the TCK.

[GQL Parser for Go](https://github.com/mburbidg/gql-parser) is an example of a repository that uses the GQL TCK by including this repository as a submodule. That repository uses the Go version of [Cucumber](https://cucumber.io/docs/installation/golang/) as the TCK runtime environment to run the TCK. It also provides other infrastructure such as Makefile, etc. to run the TCK.
