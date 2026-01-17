# 00-install-winget.ps1
# Bootstrap WinGet (App Installer) from https://aka.ms/getwinget
# Run in Windows PowerShell 5.1 or PowerShell 7. Recommended: run as Administrator.

$ErrorActionPreference = "Stop"

function Test-WinGet {
  return [bool](Get-Command winget -ErrorAction SilentlyContinue)
}

if (Test-WinGet) {
  Write-Host "WinGet already available. Skipping bootstrap." -ForegroundColor Green
  exit 0
}

Write-Host "WinGet not found. Downloading App Installer bundle..." -ForegroundColor Yellow

$TempDir = Join-Path $env:TEMP "winget-bootstrap"
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

$BundlePath = Join-Path $TempDir "Microsoft.DesktopAppInstaller.msixbundle"

# aka.ms/getwinget is Microsoft's redirect to the latest App Installer bundle.
Invoke-WebRequest -Uri "https://aka.ms/getwinget" -OutFile $BundlePath -UseBasicParsing

Write-Host "Installing App Installer (this provides winget)..." -ForegroundColor Yellow
Add-AppxPackage -Path $BundlePath

# Give WindowsApps path a moment to refresh in the current session
Start-Sleep -Seconds 2

if (-not (Test-WinGet)) {
  Write-Warning "WinGet still not found after installing App Installer."

  Write-Host @"
Common causes:
- You haven't logged into Windows as a user yet (Store registration is asynchronous).
- Required dependencies (Microsoft.VCLibs / Microsoft.UI.Xaml) aren't present on some editions.
- You may need a reboot.

Try:
1) Reboot, then run: winget --version
2) Open Microsoft Store once, then try again.
"@

  throw "WinGet bootstrap did not complete successfully."
}

Write-Host "WinGet installed successfully: $(winget --version)" -ForegroundColor Green
