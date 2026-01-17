# 00-get-winget.ps1
# Bootstraps .NET Framework 3.5 (includes 2.0/3.0) and WinGet (App Installer) from https://aka.ms/getwinget
# Recommended: run as Administrator.

$ErrorActionPreference = "Stop"

function Test-WinGet {
  return [bool](Get-Command winget -ErrorAction SilentlyContinue)
}

function Ensure-NetFx3 {
  Write-Host "Checking .NET Framework 3.5 (includes 2.0/3.0)..." -ForegroundColor Yellow

  # NetFx3 feature covers .NET 2.0 and 3.0, plus 3.5
  $feature = Get-WindowsOptionalFeature -Online -FeatureName NetFx3 -ErrorAction SilentlyContinue

  if ($feature -and $feature.State -eq "Enabled") {
    Write-Host ".NET Framework 3.5 already enabled." -ForegroundColor Green
    return
  }

  Write-Host "Enabling .NET Framework 3.5 (NetFx3)..." -ForegroundColor Yellow
  try {
    Enable-WindowsOptionalFeature -Online -FeatureName NetFx3 -All -NoRestart | Out-Host
    Write-Host ".NET Framework 3.5 enabled (reboot may be required for some apps)." -ForegroundColor Green
  } catch {
    Write-Warning @"
Failed to enable .NET Framework 3.5 automatically.
Common causes:
- Windows Update disabled / WSUS policy
- Offline install requires a source path

If you have Windows install media mounted (e.g. D:\), try:
  DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:D:\sources\sxs
"@
    throw
  }
}

function Install-WinGet {
  if (Test-WinGet) {
    Write-Host "WinGet already available. Skipping WinGet bootstrap." -ForegroundColor Green
    return
  }

  Write-Host "WinGet not found. Downloading App Installer bundle..." -ForegroundColor Yellow

  $TempDir = Join-Path $env:TEMP "winget-bootstrap"
  New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

  $BundlePath = Join-Path $TempDir "Microsoft.DesktopAppInstaller.msixbundle"

  # aka.ms/getwinget redirects to the latest App Installer MSIX bundle.
  Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile $BundlePath -UseBasicParsing

  Write-Host "Installing App Installer (provides winget)..." -ForegroundColor Yellow
  Add-AppxPackage -Path $BundlePath

  Start-Sleep -Seconds 2

  if (-not (Test-WinGet)) {
    Write-Warning @"
WinGet still not found after installing App Installer.
Try:
1) Reboot, then run: winget --version
2) Open Microsoft Store once (App Installer registration can be asynchronous)
"@
    throw "WinGet bootstrap did not complete successfully."
  }

  Write-Host "WinGet installed successfully: $(winget --version)" -ForegroundColor Green
}

# ---- Run prereqs then WinGet bootstrap ----
Ensure-NetFx3
Install-WinGet
