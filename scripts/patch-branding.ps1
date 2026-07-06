# Apply mobile app icon branding across all HTML pages (idempotent).
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$headIcons = (Get-Content (Join-Path $repoRoot "partials\head-icons.html") -Raw).TrimEnd()
$logoImg = (Get-Content (Join-Path $repoRoot "partials\logo-img.html") -Raw).TrimEnd()

$htmlFiles = @(
    (Join-Path $repoRoot "index.html"),
    (Join-Path $repoRoot "features.html"),
    (Join-Path $repoRoot "contact.html")
) + @(Get-ChildItem -Path (Join-Path $repoRoot "legal") -Filter "*.html")

foreach ($file in $htmlFiles) {
    if (-not (Test-Path $file)) { continue }
    $html = [System.IO.File]::ReadAllText($file.FullName)
    $changed = $false

    if ($html -match '<span class="logo-mark">P</span>') {
        $html = $html -replace '<span class="logo-mark">P</span>', $logoImg
        $changed = $true
    }

    if ($html -notmatch 'rel="icon"') {
        $html = $html -replace '(<meta name="theme-color"[^>]+>)', "`$1`n$headIcons"
        $changed = $true
    }

    if ($changed) {
        $utf8 = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($file.FullName, $html, $utf8)
        Write-Host "Patched $($file.Name)"
    }
}

Write-Host "Done."
