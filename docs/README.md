# Unreal Engine Documentation Scripts

This folder contains scripts for generating Unreal Engine project documentation with Doxygen.

## Requirements

* [Doxygen](https://doxygen.nl)
* [Python](https://www.python.org)

Initialize the required submodules:

```bash
git submodule update --init --recursive --remote
```

## Usage

Run:

```bat
config_doxygen.bat
```

This creates `Doxyfile` inside `devops_data` using `setup/Doxyfile.template`. The file may already exist if `setup.bat` was executed earlier.

You can also create a new configuration manually:

```bash
doxygen -g Doxyfile
```

To generate documentation, run:

```bat
generate_docs.bat
```

The generated files will be placed in the `Documentation` folder at the project root.

```text
ProjectRoot
├── Source
├── Content
├── Config
├── Documentation
├── UEDevOps
└── devops_data
```
