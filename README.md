# Download-CIArtifact

An action to download an artifact from a GitHub workflow run. Its main use case is to download artifacts from a PR CI workflow run to be used in a CD workflow.
As an example, terraform plans can be uploaded as artifacts in a PR CI workflow and then downloaded in a CD workflow to be applied, without having to re-run the terraform plan command, just reuse the plan from CI.

## Usage

### Inputs

| Name | Description | Required | Default |
| - | - | - | - |
| `WorkingDirectory` | The working directory where the artifact will be downloaded to. Default is the root of the repository. | No |  |
| `WorkflowID` | The file name or ID of the workflow to download the artifact from. | Yes |  |
| `WorkflowRunID` | The ID of the workflow run where the artifact will be download from. This is to override the default behavior of getting the workflow run ID from the PR CI workflow. | No | '' |
| `ArtifactName` | Name of the artifact to download. If unspecified, all artifacts for the run are downloaded. | Yes |  |
| `GITHUB_TOKEN` | The GitHub token used to authenticate with the GitHub API. | Yes |  |

### Outputs

N/A

### Example

Run a workflow that downloads an artifact from another workflow run.
It expects a workflow called `CI.yml` that produces an artifact called `docs`.
It can also be run manually by providing the `WorkflowRunID` input. When run manually, it will not automatically check a PR for the artifact from its
latest workflow run, but instead it will download the artifact from the specified workflow run.

```yaml
name: CD

on:
  workflow_dispatch:
    inputs:
      WorkflowRunID:
        description: The ID of the workflow run where the artifact will be download from.
        required: true
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
        WorkflowRunID: ${{ github.event.inputs.WorkflowRunID }}
        ArtifactName: docs
        GITHUB_TOKEN: ${{ github.token }}

    - name: Do what you need with the files
      shell: pwsh
      run: |
        Get-ChildItem -Path $env:GITHUB_WORKSPACE | Select-Object -Property FullName

```
