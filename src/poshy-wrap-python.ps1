#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
#Requires -Modules @{ ModuleName = "poshy-lucidity"; RequiredVersion = "0.4.1" }


function _python3() {
    if (-not $Env:PYTHON3) {
        throw "`$Env:PYTHON3 is not set."
    }
    & $Env:PYTHON3 @args
}

function shttp {
    python3 -m http.server @args
}
function pyserver {
    python3 -m http.server @args
}

Set-Alias -Name python3 -Value _python3
Set-Alias -Name py -Value _python3
Set-Alias -Name python -Value _python3


if ((Test-Command ipython3) -or (Get-Variable -Name PWSHRC_FORCE_MODULES_EXPORT_UNSUPPORTED -Scope Global -ValueOnly -ErrorAction SilentlyContinue)) {
    Set-Alias -Name ipy -Value ipython3
    Set-Alias -Name ipython -Value ipython3
}

Export-ModuleMember -Function * -Alias *
