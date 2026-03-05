# Coverage configuration for ExCoveralls
[
  # Coverage output directory for HTML reports
  output_dir: "cover",
  
  # Template for HTML coverage reports
  template_path: "cover/coverage.html",
  
  # Minimum coverage threshold (percentage)
  minimum_coverage: 90,
  
  # Files to exclude from coverage analysis
  skip_files: [
    # Test files
    ~r/^test\//,
    
    # Build artifacts
    ~r/^\/_build\//,
    
    # Dependencies
    ~r/^deps\//,
    
    # Generated files
    ~r/\.#/
  ],
  
  # Patterns to track for coverage
  coverage_options: [
    treat_no_relevant_lines_as_covered: true,
    minimum_coverage: 90,
    output: "cover"
  ]
]
