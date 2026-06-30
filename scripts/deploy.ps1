# Deploy pinfoldai.com static site to Hetzner VPS.
#
# Usage:
#   .\scripts\deploy.ps1 -Server root@91.99.152.17
#   .\scripts\deploy.ps1 -Server root@91.99.152.17 -InstallNginx
#
param(
    [Parameter(Mandatory = $true)]
    [string]$Server,
    [switch]$InstallNginx
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
$nginxConf = Join-Path $repoRoot "deploy\nginx\pinfold-www.conf"
$installScript = Join-Path $repoRoot "deploy\install-www.sh"
$tarName = "pinfold-www.tar.gz"
$tarPath = Join-Path $env:TEMP $tarName

Write-Host "=== Deploy Pinfold website (pinfoldai.com) ===" -ForegroundColor Cyan
Write-Host "Repo: $repoRoot"
Write-Host "Server: $Server"

Push-Location $repoRoot
try {
    if (Test-Path $tarPath) { Remove-Item $tarPath -Force }
    # Exclude git metadata and deploy-only paths from the public site tarball.
    tar --exclude=".git" --exclude="scripts" --exclude="deploy" --exclude="README.md" --exclude=".gitignore" -czf $tarPath .
    if (-not (Test-Path $tarPath)) {
        throw "Failed to create tarball."
    }
}
finally {
    Pop-Location
}

Write-Host "Uploading site archive..." -ForegroundColor Cyan
scp $tarPath "${Server}:/tmp/$tarName"
scp $nginxConf "${Server}:/tmp/pinfold-www.conf"
scp $installScript "${Server}:/tmp/install-www.sh"

$flag = if ($InstallNginx) { "1" } else { "0" }
ssh $Server "sed -i 's/\r$//' /tmp/install-www.sh && chmod +x /tmp/install-www.sh && /tmp/install-www.sh $flag"

Remove-Item $tarPath -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "  https://pinfoldai.com/"
Write-Host "  https://pinfoldai.com/legal/privacy.html"
Write-Host "  https://pinfoldai.com/legal/terms.html"
