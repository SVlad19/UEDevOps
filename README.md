# UEDevOps

**UEDevOps** is a lightweight automation toolkit for Unreal Engine projects. It provides a collection of scripts and configuration files that simplify common development, testing, packaging, and continuous integration tasks.

The repository can be connected to an existing Unreal Engine project and adapted to different engine versions, project structures, and build environments.

## Main Capabilities

UEDevOps can be used for:

* downloading and preparing Unreal Engine source code;
* generating Unreal Engine project files;
* building the engine from source;
* creating custom installed engine builds;
* compiling Unreal Engine projects;
* cooking and packaging project content;
* producing Game, Client, Dedicated Server, and Listen Server builds;
* formatting C++ code using `.clang-format`;
* running automated tests;
* collecting code coverage data;
* generating documentation with Doxygen;
* configuring Jenkins pipelines;
* integrating GitHub webhooks;
* sending Slack notifications;
* scheduling automated jobs.

## Installation

Add **UEDevOps** to the root directory of your Unreal Engine project as a Git submodule:

```bash
git submodule add https://github.com/SVlad19/UEDevOps
```

After cloning the submodule, open the `UEDevOps` directory.

The expected project structure should look similar to this:

```text
ProjectRoot
├── Source
├── Content
├── Config
├── ProjectName.uproject
└── UEDevOps
```

## Initialize Additional Submodules

Run the following script from the `UEDevOps` directory:

```bat
update_submodules.bat
```

This step initializes additional dependencies used by UEDevOps.

## Run the Setup Script

From the same `UEDevOps` directory, execute:

```bat
setup.bat
```

The setup script creates a new `devops_data` directory in the root of your Unreal Engine project.

## Configuration

The primary configuration file is:

```text
devops_data/config.bat
```

Before using the scripts, update the variables inside this file according to your local environment.

The main variables are:

```bat
EnginePath=
ProjectPureName=
VersionSelector=
TestNames=
```

### EnginePath

The local path to the Unreal Engine installation or source build.

Example:

```bat
set EnginePath=C:\UnrealEngine\UE_5.6
```

### ProjectPureName

The Unreal Engine project name without the `.uproject` extension.

Example:

```bat
set ProjectPureName=MyGame
```

### VersionSelector

The Unreal Engine version selector used for generating project files.

Example:

```bat
set VersionSelector=C:\Program Files (x86)\Epic Games\Launcher\Engine\Binaries\Win64\UnrealVersionSelector.exe
```

If you are the only developer working with the repository, `config.bat` may be committed to version control.

For team projects, it is usually better to keep `config.bat` local because engine paths and environment settings may differ between developers and build machines.

## Doxygen Configuration

The generated `Doxyfile` is used for project documentation generation.

Update its properties before running the documentation script. At minimum, change the project name:

```text
PROJECT_NAME = "My Project"
```

You may commit `Doxyfile` if the entire team uses the same documentation settings.

When documentation generation is not required, both `Doxyfile` and the related scripts can be removed.

## Generated Scripts

The setup process creates several helper scripts.

### Generate Project Files

```bat
generate_project_files.bat
```

Generates IDE project files for the configured Unreal Engine project.

### Format Source Files

```bat
format_all_files.bat
```

Formats supported source files using the generated `.clang-format` configuration.

### Clean Intermediate Files

```bat
clean_intermediate_files.bat
```

Removes temporary Unreal Engine build directories and generated files.

### Run Automated Tests

```bat
run_tests.bat
```

Starts the configured Unreal Engine automation tests.

### Generate Documentation

```bat
generate_docs.bat
```

Generates project documentation using Doxygen.

## Repository Organization

All generated files are optional.

You may:

* leave them inside `devops_data`;
* move frequently used scripts to the project root;
* commit shared configuration files;
* keep machine-specific files local;
* remove scripts that are not required by your project.

A simplified final structure may look like this:

```text
ProjectRoot
├── Source
├── Content
├── Config
├── ProjectName.uproject
├── UEDevOps
│   ├── update_submodules.bat
│   ├── setup.bat
│   └── ...
├── devops_data
│   ├── config.bat
│   └── Doxyfile
├── format_all_files.bat
├── generate_project_files.bat
├── clean_intermediate_files.bat
├── run_tests.bat
├── generate_docs.bat
├── .clang-format
├── .gitignore
├── LICENSE.md
└── README.md
```

## Requirements

The exact requirements depend on the automation features used by the project.

Typical dependencies include:

* Git;
* Unreal Engine or Unreal Engine source code;
* Visual Studio with C++ development tools;
* Windows batch scripting support;
* Doxygen for documentation generation;
* Jenkins for CI pipelines.