[CmdletBinding()]
param(
    [Parameter()]
    [string] $Subject = $env:GITHUB_ACTION_INPUT_subject
)

Write-Output "::group::Get PR"
$PR = gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "/repos/$env:GITHUB_REPOSITORY/commits/$env:GITHUB_SHA/pulls" | ConvertFrom-Json
$PR  | ConvertTo-Json -Depth 100

Write-Output "::group::Get WorkflowRun"
$WorkflowRuns = gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "/repos/$env:GITHUB_REPOSITORY/actions/workflows/CI.yml/runs?head_sha=$($PR.head.sha)" | ConvertFrom-Json | Select-Object -ExpandProperty workflow_runs
$WorkflowRuns | ConvertTo-Json -Depth 100
Write-Output "::endgroup::"

"run-id=$($WorkflowRuns.id)" | Out-File -FilePath $env:GITHUB_OUTPUT -Append