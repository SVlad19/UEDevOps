# Unreal Engine Testing Scripts

This folder contains scripts and utilities for Unreal Engine automated testing and code coverage.

## Requirements

* [Python](https://www.python.org)
* [OpenCppCoverage](https://github.com/OpenCppCoverage/OpenCppCoverage/releases/tag/release-0.9.9.0)
* [Node.js](https://nodejs.org/en/download)

## Scripts

* `create_spec_file.bat` — creates a new spec test file.
* `create_test_file.bat` — creates a legacy test file.
* `setup_tests.bat` — installs local test dependencies into the ignored `data` folder.
* `run_tests.bat` — runs all tests and generates test and coverage reports.

## Utils

The `Utils` folder contains helper files for writing tests. Copy them into your project:

```cpp
#include "Utils/JsonUtils.h"
```

Add the required modules to `MyGame.Build.cs`:

```cpp
PublicDependencyModuleNames.AddRange(
    new string[] { "Json", "JsonUtilities", "UMG", "EnhancedInput" }

    if (Target.Configuration != UnrealTargetConfiguration.Shipping)
    {
        PublicDependencyModuleNames.Add("FunctionalTesting");
    }
);
```
