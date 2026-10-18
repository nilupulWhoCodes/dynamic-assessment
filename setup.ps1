<#
    One-time setup for the FYP project on Windows.

    Open PowerShell in this folder and run:

        powershell -ExecutionPolicy Bypass -File .\setup.ps1

    It creates a project-local virtual environment (.venv), installs the
    dependencies into it, and registers it as a Jupyter kernel so the notebook
    can find it. Safe to re-run.
#>

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

Write-Host "`n[1/5] Checking Python..." -ForegroundColor Cyan
$pyExe = $null
$pyArgs = @()
foreach ($cand in @(@('py', @('-3')), @('python', @()))) {
    try {
        $v = & $cand[0] @($cand[1]) --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pyExe = $cand[0]; $pyArgs = $cand[1]
            Write-Host "      found: $v"
            break
        }
    } catch { }
}
if (-not $pyExe) {
    throw "Python was not found. Install it from https://www.python.org/downloads/ and tick 'Add python.exe to PATH', then reopen PowerShell."
}

Write-Host "`n[2/5] Checking Git..." -ForegroundColor Cyan
try {
    $gv = git --version
    Write-Host "      found: $gv"
} catch {
    throw "Git was not found. Install Git for Windows from https://git-scm.com/downloads, then reopen PowerShell."
}

Write-Host "`n[3/5] Creating virtual environment (.venv)..." -ForegroundColor Cyan
if (Test-Path '.venv') {
    Write-Host "      .venv already exists - reusing it."
} else {
    & $pyExe @pyArgs -m venv .venv
}

$vpy = Join-Path $PSScriptRoot '.venv\Scripts\python.exe'

Write-Host "`n[4/5] Installing dependencies (a few minutes the first time)..." -ForegroundColor Cyan
& $vpy -m pip install --upgrade pip
& $vpy -m pip install -r requirements.txt

Write-Host "`n[5/5] Registering the Jupyter kernel..." -ForegroundColor Cyan
& $vpy -m ipykernel install --user --name fyp --display-name "Python 3 (fyp venv)"

Write-Host "`nDone." -ForegroundColor Green
Write-Host "Start JupyterLab with:" -ForegroundColor Green
Write-Host "    .\.venv\Scripts\Activate.ps1"
Write-Host "    jupyter lab"
Write-Host "Then open notebooks\Notebook_01_Setup_and_Exploration.ipynb and pick the 'Python 3 (fyp venv)' kernel.`n"
