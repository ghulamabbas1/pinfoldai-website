# Extract English i18n strings from legal content body fragments.
$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$contentDir = Join-Path $repoRoot "legal\content"
$outPath = Join-Path $repoRoot "js\i18n-legal-suite-en.json"

$entries = @{}

Get-ChildItem $contentDir -Filter "*.body.html" | ForEach-Object {
    $html = Get-Content $_.FullName -Raw
    foreach ($m in [regex]::Matches($html, 'data-i18n(?:-html)?="([^"]+)"[^>]*>([\s\S]*?)</')) {
        $key = $m.Groups[1].Value
        $val = $m.Groups[2].Value.Trim()
        if ($val -and -not $entries.ContainsKey($key)) {
            $entries[$key] = $val
        }
    }
}

$entries | ConvertTo-Json -Depth 3 | Set-Content $outPath -Encoding UTF8
Write-Host "Extracted $($entries.Count) keys to $outPath"
