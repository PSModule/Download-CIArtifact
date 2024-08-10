# Template-action

A template repository for GitHub Actions

## Usage

### Inputs

### Outputs

### Example

```yaml
name: CD

on:
  workflow_dispatch:
    inputs:
    
  push:
    branches:
      - main

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - name: Get PR info
      uses: PSModule/Download-CIArtifact@init
      with:
        WorkflowID: CI.yml
        ArtifactName: docs
        GITHUB_TOKEN: ${{ github.token }}

    - name: Debug
      uses: PSModule/Debug@main

```
