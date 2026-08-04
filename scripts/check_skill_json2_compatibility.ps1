[CmdletBinding()]
param(
    [string]$SkillPath = (Join-Path (Split-Path -Parent $PSScriptRoot) "lark-card-designer")
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
    ).Replace([System.IO.Path]::DirectorySeparatorChar, "/")
}

$skillRoot = Get-NormalizedPath $SkillPath
if (-not (Test-Path -LiteralPath $skillRoot -PathType Container)) {
    throw "Skill directory does not exist: $skillRoot"
}

$requiredFiles = @(
    "SKILL.md",
    "references/data-visualization-rules.md",
    "references/json-2.0-compatibility-rules.md",
    "references/pattern-structure-sketches.md"
)

foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $skillRoot $relativePath
    if (-not (Test-Path -LiteralPath $fullPath -PathType Leaf)) {
        throw "Required compatibility file is missing: $relativePath"
    }
}

$runtimeFiles = @()
$runtimeFiles += Get-Item -LiteralPath (Join-Path $skillRoot "SKILL.md")
foreach ($directoryName in @("agents", "adapters", "references")) {
    $directoryPath = Join-Path $skillRoot $directoryName
    if (Test-Path -LiteralPath $directoryPath -PathType Container) {
        $runtimeFiles += Get-ChildItem -LiteralPath $directoryPath -Recurse -File |
            Where-Object { $_.Extension -in @(".md", ".yaml", ".yml") }
    }
}

$warningOnlyFiles = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)
foreach ($relativePath in @(
    "SKILL.md",
    "references/evaluation-cases.md",
    "references/json-2.0-compatibility-rules.md",
    "references/rendering-constraints.md"
)) {
    [void]$warningOnlyFiles.Add($relativePath)
}

$blockedConceptPattern = 'json_2_0_like|chart_or_markdown|chart_or_table|markdown_or_rich_text|markdown_or_note|markdown_or_step_list|column_set_or_table|button_group(?:_optional)?|form_optional'
$blockedTagPattern = '"tag"\s*:\s*"(?:note|action|collapsible|button_group(?:_optional)?|form_optional|chart_or_markdown|chart_or_table|markdown_or_rich_text|markdown_or_note|markdown_or_step_list|column_set_or_table)"'
$rootElementsPattern = '^\s*"elements"\s*:'
$findings = [System.Collections.Generic.List[string]]::new()

foreach ($file in $runtimeFiles) {
    $relativePath = Get-RelativePath $skillRoot $file.FullName
    $lines = Get-Content -LiteralPath $file.FullName -Encoding utf8

    for ($index = 0; $index -lt $lines.Count; $index++) {
        $line = $lines[$index]
        $lineNumber = $index + 1

        if (-not $warningOnlyFiles.Contains($relativePath) -and $line -match $blockedConceptPattern) {
            $findings.Add("$relativePath`:$lineNumber contains a blocked pseudo-component or pseudo-schema name")
        }

        if (-not $warningOnlyFiles.Contains($relativePath) -and $line -match $blockedTagPattern) {
            $findings.Add("$relativePath`:$lineNumber contains an invented or deprecated JSON tag")
        }

        if (-not $warningOnlyFiles.Contains($relativePath) -and $line -match $rootElementsPattern) {
            $findings.Add("$relativePath`:$lineNumber contains a root-style JSON elements property")
        }
    }
}

$patternSketchPath = Join-Path $skillRoot "references/pattern-structure-sketches.md"
$patternSketchLines = Get-Content -LiteralPath $patternSketchPath -Encoding utf8
for ($index = 0; $index -lt $patternSketchLines.Count; $index++) {
    $line = $patternSketchLines[$index]
    $lineNumber = $index + 1
    if ($line -match '^\s*```json\s*$') {
        $findings.Add("references/pattern-structure-sketches.md`:$lineNumber contains a JSON fence; use a text component map")
    }
    if ($line -match '"tag"\s*:') {
        $findings.Add("references/pattern-structure-sketches.md`:$lineNumber contains JSON-looking tag syntax")
    }
}

$skillText = Get-Content -Raw -LiteralPath (Join-Path $skillRoot "SKILL.md") -Encoding utf8
foreach ($requiredText in @(
    "data-visualization-rules.md",
    "json-2.0-compatibility-rules.md",
    "chart_decision:",
    "number_emphasis_rules:",
    "feasibility_check:",
    "official_components:",
    "conditional_components:",
    "conceptual_only_patterns:",
    "unsupported_or_unverified_requests:",
    "implementation_verification_needed:"
)) {
    if (-not $skillText.Contains($requiredText)) {
        $findings.Add("SKILL.md is missing required compatibility marker: $requiredText")
    }
}

if ($findings.Count -gt 0) {
    Write-Error ("JSON 2.0 compatibility check failed:`n- " + ($findings -join "`n- "))
    exit 1
}

Write-Output "JSON 2.0 compatibility check passed for $($runtimeFiles.Count) runtime Skill files."
