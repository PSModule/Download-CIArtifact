[CmdletBinding(DefaultParameterSetName = 'WorkflowID')]
param(
    # The ID of the workflow to get the run for.
    [Parameter()]
    [string] $WorkflowID = $env:GITHUB_ACTION_INPUT_WorkflowID,

    # The ID of the workflow run to verify.
    [Parameter()]
    [string] $WorkflowRunID = $env:GITHUB_ACTION_INPUT_WorkflowRunID
)

if ($WorkflowRunID) {
    Write-Output '::group::Verify Workflow Run'
    gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' "/repos/$env:GITHUB_REPOSITORY/actions/runs/$WorkflowRunID"
    "RunID=$WorkflowRunID" | Out-File -FilePath $env:GITHUB_OUTPUT -Append
    Write-Output '::endgroup::'
    return
} else {
    Write-Output '::group::Get PR'
    $PR = gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' `
        "/repos/$env:GITHUB_REPOSITORY/commits/$env:GITHUB_SHA/pulls" | ConvertFrom-Json
    $PR | ConvertTo-Json -Depth 100
    Write-Output '::endgroup::'

    Write-Output '::group::Get WorkflowRun'
    $WorkflowRuns = gh api -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' `
        "/repos/$env:GITHUB_REPOSITORY/actions/workflows/$WorkflowID/runs?head_sha=$($PR.head.sha)" |
        ConvertFrom-Json | Select-Object -ExpandProperty workflow_runs
    $WorkflowRuns | ConvertTo-Json -Depth 100
    $WorkflowRunID = $WorkflowRuns.id
    Write-Output '::endgroup::'
}

Write-Output "Workflow Run ID: [$WorkflowRunID]"

"RunID=$WorkflowRunID" | Out-File -FilePath $env:GITHUB_OUTPUT -Append
