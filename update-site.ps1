$ErrorActionPreference = "Stop"

$workspace = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $workspace

$git = "C:\Program Files\Git\cmd\git.exe"
if (-not (Test-Path $git)) {
    throw "Git not found at $git"
}

$sourceFile = Join-Path $workspace "Silver Value.html"
$siteFile = Join-Path $workspace "index.html"

if (-not (Test-Path $sourceFile)) {
    throw "Missing source file: $sourceFile"
}

Copy-Item -Path $sourceFile -Destination $siteFile -Force

& $git add "Silver Value.html" "index.html" "README.md" "update-site.ps1"

& $git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "No changes to publish."
    exit 0
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
& $git commit -m "Update site ($timestamp)"
& $git push

Write-Host "Published successfully." -ForegroundColor Green
Write-Host "Live URL: https://bkbodegacat.github.io/coin-collecting-web/" -ForegroundColor Green
