param(
    [string]$RepoName = "coin-collectiing-web",
    [switch]$Private
)

$ErrorActionPreference = "Stop"

$workspace = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $workspace

$git = "C:\Program Files\Git\cmd\git.exe"
$gh = "C:\Program Files\GitHub CLI\gh.exe"

if (-not (Test-Path $git)) { throw "Git not found at $git" }
if (-not (Test-Path $gh)) { throw "GitHub CLI not found at $gh" }

if (-not (Test-Path ".\index.html")) {
    throw "index.html not found in $workspace"
}

& $git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    & $git init
}

& $git branch -M main
& $git add index.html README.md publish-github-pages.ps1

$hasCommit = $true
& $git rev-parse --verify HEAD *> $null
if ($LASTEXITCODE -ne 0) { $hasCommit = $false }

if ($hasCommit) {
    & $git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        & $git commit -m "Update site for GitHub Pages"
    }
} else {
    & $git commit -m "Initial public site"
}

& $gh auth status *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "GitHub login required. Starting device login..." -ForegroundColor Yellow
    & $gh auth login --hostname github.com --git-protocol https --web --clipboard
}

$user = & $gh api user --jq .login
if (-not $user) { throw "Unable to determine GitHub username." }

& $gh repo view $RepoName *> $null
if ($LASTEXITCODE -ne 0) {
    if ($Private) {
        & $gh repo create $RepoName --private --source . --remote origin --push
    } else {
        & $gh repo create $RepoName --public --source . --remote origin --push
    }
} else {
    & $git remote get-url origin *> $null
    if ($LASTEXITCODE -ne 0) {
        & $git remote add origin "https://github.com/$user/$RepoName.git"
    }
    & $git push -u origin main
}

& $gh api "/repos/$user/$RepoName/pages" -X POST -f source[branch]=main -f source[path]=/ *> $null

$siteUrl = "https://$user.github.io/$RepoName/"
Write-Host "Published. Repo: https://github.com/$user/$RepoName" -ForegroundColor Green
Write-Host "Site URL: $siteUrl" -ForegroundColor Green
