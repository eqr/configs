IMPORTANT: Never write, edit, or modify any code files without explicit user approval first.
When writing a commit, never write that the commit was co-authored by Claude.
 Code Style & Architecture Guidelines:

  Naming & Structure:
  - Avoid unnecessary suffixes like "Impl" for implementation types
  - Keep documentation clean and minimal - prefer simple status indicators
  - Place generated code (mocks, etc.) in dedicated subdirectories
  - Use go:generate directives in source files that define interfaces

  Testing Philosophy:
  - Use established mocking frameworks over hand-written test doubles
  - Test actual implementations, not simplified test versions
  - Focus tests on business logic and domain concerns, not third-party library
  internals

  Architecture Decisions:
  - Question "Not Invented Here" syndrome - prefer battle-tested libraries
  - Avoid creating packages solely to resolve import cycles
  - Choose simple, generic solutions over complex custom ones
  - When using external libraries, eliminate obsolete internal implementations

  Decision Process:
  - When facing multiple options, prioritize highest impact for lowest effort
  - Be explicit about what's implemented vs. placeholder/temporary code
  - Validate architectural assumptions early rather than building on shaky
  foundations

  Go Pointer Guidelines:
  - Default to value types for structs, receivers, and parameters
  - Only use pointers when explicitly required:
    * Need to mutate the struct itself (not just call methods on its fields)
    * Resource handles (files, network connections, etc.)
    * Large structs where copying is expensive
    * Need to share the exact same instance across goroutines
  - Interfaces are always passed by value (they're references internally)
  - Value receivers are preferred unless the method needs to modify the struct


- don't write comments to removed code, they reference nothing and don't provide any value