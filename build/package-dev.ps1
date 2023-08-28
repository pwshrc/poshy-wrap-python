#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Take all the PowerShell module content in ../src and package it as a NuPkg. (But only for local development purposes.)
#>
param(
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest


[string] $gitversion_bin = $null
if (Get-Command dotnet-gitversion -ErrorAction SilentlyContinue) {
    $gitversion_bin = Get-Command dotnet-gitversion
}
elseif (Get-Command gitversion -ErrorAction SilentlyContinue) {
    $gitversion_bin = Get-Command gitversion
}

if ($gitversion_bin) {
    [PSObject] $versionInfo = & $gitversion_bin | ConvertFrom-Json

    [string] $PackageVersionNuGet = $versionInfo | Select-Object -ExpandProperty NuGetVersionV2
    [string] $PackageVersionPrereleaseTag = $versionInfo | Select-Object -ExpandProperty PreReleaseTag
    [string] $PackageVersionMajorMinorPatchBuild = $versionInfo | Select-Object -ExpandProperty AssemblySemVer
    [string] $CommitSha = $versionInfo | Select-Object -ExpandProperty Sha
} else {
    [string] $PackageVersionNuGet = "0.0.1"
    [string] $PackageVersionPrereleaseTag = $null
    [string] $PackageVersionMajorMinorPatchBuild = "0.0.1.0"
    [string] $CommitSha = (git rev-parse HEAD)
}
[string] $ReleaseNotes = "Fake Release Notes"

if (-not $PackageVersionPrereleaseTag) {
    $PackageVersionNuGet += "-dev"
    $PackageVersionPrereleaseTag = "dev"
} else {
    $PackageVersionNuGet = $PackageVersionNuGet.Replace("-" + $PackageVersionPrereleaseTag, "-dev-" + $PackageVersionPrereleaseTag)
    $PackageVersionPrereleaseTag = "dev-" + $PackageVersionPrereleaseTag
}

[string] $ds = [System.IO.Path]::DirectorySeparatorChar
& "${PSScriptRoot}${ds}package.ps1" `
    -PackageVersionNuGet $PackageVersionNuGet `
    -PackageVersionMajorMinorPatchBuild $PackageVersionMajorMinorPatchBuild `
    -PackageVersionPrereleaseTag $PackageVersionPrereleaseTag `
    -ReleaseNotes $ReleaseNotes `
    -CommitSha $CommitSha
