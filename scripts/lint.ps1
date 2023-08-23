#!/usr/bin/env pwsh
param(
    [switch] $NoFail
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


if (-not (Get-Command Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue)) {
    throw "Invoke-ScriptAnalyzer not found. Please install the PowerShell module 'PSScriptAnalyzer'."
}
$ds = [System.IO.Path]::DirectorySeparatorChar
Invoke-ScriptAnalyzer -Path "${PSScriptRoot}${ds}..${ds}**${ds}*" -Recurse -ReportSummary -OutVariable issues
$errors   = $issues.Where({$_.Severity -eq 'Error'})
$warnings = $issues.Where({$_.Severity -eq 'Warning'})
if ($errors -and (-not $NoFail)) {
    Write-Error "There were $($errors.Count) errors and $($warnings.Count) warnings total." -ErrorAction Stop
} else {
    Write-Output "There were $($errors.Count) errors and $($warnings.Count) warnings total."
}
