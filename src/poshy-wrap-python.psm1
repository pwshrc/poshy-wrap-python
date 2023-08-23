#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


Get-ChildItem -Path "$PSScriptRoot/*.ps1" | ForEach-Object {
    . $_.FullName
}

if (Test-Command ipython3) {
    Set-Alias -Name ipy -Value ipython3
    Set-Alias -Name ipython -Value ipython3
}

Export-ModuleMember -Function * -Alias *
