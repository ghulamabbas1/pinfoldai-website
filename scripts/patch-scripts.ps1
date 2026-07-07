# Normalize footer script tags across all pages.
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$marketingScripts = (Get-Content (Join-Path $repoRoot "partials\scripts-marketing.html") -Raw).TrimEnd()
$legalScripts = (Get-Content (Join-Path $repoRoot "partials\scripts-legal.html") -Raw).TrimEnd()
$scriptPattern = '(?s)\s*<script src="/js/i18n\.js"></script>.*?</body>'

$marketingFiles = @(
    (Join-Path $repoRoot "index.html"),
    (Join-Path $repoRoot "features.html"),
    (Join-Path $repoRoot "contact.html")
)

foreach ($file in $marketingFiles) {
    $html = [System.IO.File]::ReadAllText($file)
    $html = [regex]::Replace($html, $scriptPattern, "`n$marketingScripts`n</body>")
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file, $html, $utf8)
    Write-Host "Fixed marketing: $(Split-Path -Leaf $file)"
}

foreach ($file in Get-ChildItem (Join-Path $repoRoot "legal") -Filter "*.html") {
    $html = [System.IO.File]::ReadAllText($file.FullName)
    $html = [regex]::Replace($html, $scriptPattern, "`n$legalScripts`n</body>")
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($file.FullName, $html, $utf8)
    Write-Host "Fixed legal: $($file.Name)"
}

Write-Host "Done."
