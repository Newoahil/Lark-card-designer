[CmdletBinding()]
param(
    [string]$Source = (Join-Path (Split-Path -Parent $PSScriptRoot) "lark-card-designer"),
    [string[]]$Targets = @(
        (Join-Path $env:USERPROFILE ".codex\skills\lark-card-designer"),
        (Join-Path $env:USERPROFILE ".cc-switch\skills\lark-card-designer")
    ),
    [switch]$NoPrune
)

$ErrorActionPreference = "Stop"

function Get-NormalizedPath {
    param([Parameter(Mandatory)][string]$Path)

    return [System.IO.Path]::GetFullPath($Path).TrimEnd(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )
}

function Get-RelativePath {
    param(
        [Parameter(Mandatory)][string]$BasePath,
        [Parameter(Mandatory)][string]$ChildPath
    )

    return $ChildPath.Substring($BasePath.Length).TrimStart(
        [System.IO.Path]::DirectorySeparatorChar,
        [System.IO.Path]::AltDirectorySeparatorChar
    )
}

$sourcePath = Get-NormalizedPath $Source
if (-not (Test-Path -LiteralPath $sourcePath -PathType Container)) {
    throw "Skill source does not exist: $sourcePath"
}

$sourceLeaf = [System.IO.Path]::GetFileName($sourcePath)
if ($sourceLeaf -ne "lark-card-designer") {
    throw "Skill source directory must be named lark-card-designer: $sourcePath"
}

$sourceFiles = Get-ChildItem -LiteralPath $sourcePath -Recurse -File
$sourceRelativeFiles = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)
foreach ($file in $sourceFiles) {
    [void]$sourceRelativeFiles.Add((Get-RelativePath $sourcePath $file.FullName))
}

foreach ($target in $Targets) {
    $targetPath = Get-NormalizedPath $target
    $targetLeaf = [System.IO.Path]::GetFileName($targetPath)
    $targetParent = [System.IO.Path]::GetDirectoryName($targetPath)
    $targetParentLeaf = [System.IO.Path]::GetFileName($targetParent)

    if ($targetPath -eq $sourcePath) {
        throw "Refusing to synchronize the Skill onto its source directory: $targetPath"
    }
    if ($targetPath.StartsWith($sourcePath + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Refusing to synchronize into a directory nested inside the Skill source: $targetPath"
    }
    if ($targetLeaf -ne $sourceLeaf -or $targetParentLeaf -ne "skills") {
        throw "Target must end with skills\lark-card-designer: $targetPath"
    }

    New-Item -ItemType Directory -Path $targetPath -Force | Out-Null

    $sourceDirectories = Get-ChildItem -LiteralPath $sourcePath -Recurse -Directory |
        Sort-Object FullName
    foreach ($directory in $sourceDirectories) {
        $relativePath = Get-RelativePath $sourcePath $directory.FullName
        New-Item -ItemType Directory -Path (Join-Path $targetPath $relativePath) -Force | Out-Null
    }

    foreach ($file in $sourceFiles) {
        $relativePath = Get-RelativePath $sourcePath $file.FullName
        $destination = Join-Path $targetPath $relativePath
        $destinationParent = Split-Path -Parent $destination
        New-Item -ItemType Directory -Path $destinationParent -Force | Out-Null
        Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
    }

    if (-not $NoPrune) {
        $targetFiles = Get-ChildItem -LiteralPath $targetPath -Recurse -File
        foreach ($file in $targetFiles) {
            $relativePath = Get-RelativePath $targetPath $file.FullName
            if (-not $sourceRelativeFiles.Contains($relativePath)) {
                $resolvedFile = Get-NormalizedPath $file.FullName
                if (-not $resolvedFile.StartsWith($targetPath + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
                    throw "Refusing to remove a file outside the verified target: $resolvedFile"
                }
                Remove-Item -LiteralPath $resolvedFile -Force
            }
        }

        $targetDirectories = Get-ChildItem -LiteralPath $targetPath -Recurse -Directory |
            Sort-Object { $_.FullName.Length } -Descending
        foreach ($directory in $targetDirectories) {
            if (-not (Get-ChildItem -LiteralPath $directory.FullName -Force)) {
                $resolvedDirectory = Get-NormalizedPath $directory.FullName
                if (-not $resolvedDirectory.StartsWith($targetPath + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase)) {
                    throw "Refusing to remove a directory outside the verified target: $resolvedDirectory"
                }
                Remove-Item -LiteralPath $resolvedDirectory -Force
            }
        }
    }

    foreach ($file in $sourceFiles) {
        $relativePath = Get-RelativePath $sourcePath $file.FullName
        $destination = Join-Path $targetPath $relativePath
        if (-not (Test-Path -LiteralPath $destination -PathType Leaf)) {
            throw "Synchronized file is missing: $destination"
        }

        $sourceHash = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            throw "Hash mismatch after synchronization: $relativePath"
        }
    }

    if (-not $NoPrune) {
        $targetFileCount = (Get-ChildItem -LiteralPath $targetPath -Recurse -File).Count
        if ($targetFileCount -ne $sourceFiles.Count) {
            throw "Target contains an unexpected file count after synchronization: $targetPath"
        }
    }

    Write-Output "Synchronized $($sourceFiles.Count) files to $targetPath"
}
