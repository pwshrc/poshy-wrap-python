#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


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
