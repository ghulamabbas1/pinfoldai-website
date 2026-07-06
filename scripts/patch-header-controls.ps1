# Insert static theme/lang controls into page headers (idempotent).
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$partial = Join-Path $repoRoot "partials\header-controls.html"
$controls = (Get-Content $partial -Raw).TrimEnd()
$marker = 'id="header-controls"'

$files = @(
    (Join-Path $repoRoot "index.html"),
    (Join-Path $repoRoot "features.html"),
    (Join-Path $repoRoot "contact.html"),
    (Join-Path $repoRoot "legal\index.html"),
    (Join-Path $repoRoot "legal\data-deletion.html"),
    (Join-Path $repoRoot "legal\license.html")
)

$scriptOld = @(
    '  <script src="/js/i18n-legal-suite.js"></script>',
    '  <script src="/js/site.js"></script>'
)
$scriptNew = @(
    '  <script defer src="/js/i18n-legal-suite.js"></script>',
    '  <script defer src="/js/site.js"></script>'
)

foreach ($file in $files) {
    if (-not (Test-Path $file)) {
        Write-Warning "Skip missing: $file"
        continue
    }
    $html = Get-Content $file -Raw
    if ($html -notmatch [regex]::Escape($marker)) {
        $html = $html -replace '(</a>\s*)(<nav class="nav-desktop">)', "`$1$controls`n      `$2"
        Write-Host "Patched header: $file"
    }
    $html = $html.Replace($scriptOld[0], $scriptNew[0]).Replace($scriptOld[1], $scriptNew[1])
    [System.IO.File]::WriteAllText($file, $html)
}

Write-Host "Done."
