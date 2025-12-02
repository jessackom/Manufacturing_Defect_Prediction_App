# PowerShell script to rename the package folder and replace references.
# Run from repository root in PowerShell:
# ./tools/rename_package.ps1
param()
$OldName = "Manufacturing-Defect-Prediction-App"
$NewName = "manufacturing_defect_prediction_app"

$Candidates = @(
  Join-Path -Path (Get-Location) -ChildPath $OldName
  Join-Path -Path (Get-Location) -ChildPath ("src\" + $OldName)
)

$FoundPath = $null
foreach ($p in $Candidates) {
  if (Test-Path $p -PathType Container) {
    $FoundPath = $p
    break
  }
}

if (-not $FoundPath) {
  Write-Error "Could not find directory $OldName at repo root or under src\."
  exit 1
}

$NewPath = Join-Path -Path (Split-Path $FoundPath -Parent) -ChildPath $NewName
Write-Host "Renaming: $FoundPath -> $NewPath"

# Ensure git repository
if (-not (Test-Path .git)) {
  Write-Error "Not a git repository. Run from the repo root."
  exit 1
}

git mv -- "$FoundPath" "$NewPath"

# Replace occurrences in tracked files (for .py, .md, .yml, .txt, .ipynb)
$extensions = '*.py','*.md','*.yml','*.yaml','*.txt','*.ipynb','*.cfg','*.toml','*.ini','Dockerfile'
$files = git ls-files --others --exclude-standard -o --directory --no-empty-directory | Out-Null
# Use Get-ChildItem for replacement across known extensions
Get-ChildItem -Path . -Recurse -Include $extensions -File |
  ForEach-Object {
    (Get-Content -Raw $_.FullName) -replace $OldName, $NewName | Set-Content $_.FullName
  }

# Update pyproject.toml include if present
if (Test-Path "pyproject.toml") {
  (Get-Content pyproject.toml) -replace $OldName, $NewName | Set-Content pyproject.toml
  Write-Host "Updated pyproject.toml (best effort)."
}

git add -A
git commit -m "Rename package: $OldName -> $NewName and update imports/references"
Write-Host "Rename complete. Run `git push origin HEAD` to push."
