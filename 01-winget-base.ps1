# 01-install-apps.ps1
# Win11 Baseline Setup - winget installer
# This script will bootstrap winget via 00-get-winget.ps1 if needed.

$ErrorActionPreference = "Stop"

function Test-WinGet {
  return [bool](Get-Command winget -ErrorAction SilentlyContinue)
}

function Ensure-WinGet {
  if (Test-WinGet) { return }

  $scriptDir = Split-Path -Parent $PSCommandPath
  $bootstrap = Join-Path $scriptDir "00-get-winget.ps1"

  if (-not (Test-Path $bootstrap)) {
    throw "winget not found and bootstrap script missing: $bootstrap"
  }

  Write-Host "winget not found. Running bootstrap: $bootstrap" -ForegroundColor Yellow
  & powershell -ExecutionPolicy Bypass -File $bootstrap

  if (-not (Test-WinGet)) {
    throw "winget still not available after running 00-get-winget.ps1"
  }
}

function Install-WinGetPackage {
  param(
    [Parameter(Mandatory=$true)][string]$Id,
    [string]$Name = $Id
  )

  Write-Host "`n==> Installing: $Name ($Id)" -ForegroundColor Cyan

  $args = @(
    "install", "--id", $Id,
    "-e",
    "--accept-source-agreements",
    "--accept-package-agreements",
    "--disable-interactivity",
    "--silent"
  )

  try {
    winget @args | Out-Host
  } catch {
    Write-Warning "Install failed (possibly due to silent mode). Retrying without --silent: $Id"
    $argsNoSilent = $args | Where-Object { $_ -ne "--silent" }
    winget @argsNoSilent | Out-Host
  }
}

# ---- Ensure winget (and prereqs via bootstrap) ----
Ensure-WinGet

# ----------------------------
# Browsers
# ----------------------------
$Browsers = @(
  @{ Id = "Google.Chrome"; Name = "Google Chrome" },
  @{ Id = "Brave.Brave"; Name = "Brave Browser" }
)

# ----------------------------
# System Essentials & Hardware Control
# ----------------------------
$SystemEssentials = @(
  @{ Id = "7zip.7zip"; Name = "7-Zip" },
  @{ Id = "Klocman.BulkCrapUninstaller"; Name = "Bulk Crap Uninstaller" },
  @{ Id = "Microsoft.Sysinternals"; Name = "Sysinternals Suite" },

  @{ Id = "REALiX.HWiNFO"; Name = "HWiNFO" },
  @{ Id = "LibreHardwareMonitor.LibreHardwareMonitor"; Name = "LibreHardwareMonitor" },
  @{ Id = "CPUID.CPU-Z"; Name = "CPU-Z" },
  @{ Id = "TechPowerUp.GPU-Z"; Name = "GPU-Z" },

  @{ Id = "GSmartControl.GSmartControl"; Name = "GSmartControl" },
  @{ Id = "CrystalDewWorld.CrystalDiskInfo"; Name = "CrystalDiskInfo" },
  @{ Id = "CrystalDewWorld.CrystalDiskMark"; Name = "CrystalDiskMark" },
  @{ Id = "ATTO.DiskBenchmark"; Name = "ATTO Disk Benchmark" },

  @{ Id = "Rem0o.FanControl"; Name = "FanControl" },
  @{ Id = "Guru3D.Afterburner"; Name = "MSI Afterburner" },
  @{ Id = "Guru3D.RTSS"; Name = "RivaTuner Statistics Server (RTSS)" },

  @{ Id = "Mersenne.Prime95"; Name = "Prime95" },
  @{ Id = "OCBase.OCCT.Personal"; Name = "OCCT (Personal)" },
  @{ Id = "Maxon.CinebenchR23"; Name = "Cinebench R23" },

  @{ Id = "UweSieber.UsbTreeView"; Name = "USB Device Tree Viewer" },
  @{ Id = "Resplendence.LatencyMon"; Name = "LatencyMon" }
)

# ----------------------------
# Networking & Diagnostics
# ----------------------------
$Networking = @(
  @{ Id = "WiresharkFoundation.Wireshark"; Name = "Wireshark" },
  @{ Id = "Insecure.Nmap"; Name = "Nmap" },
  @{ Id = "ESnet.Iperf3"; Name = "iperf3" },
  @{ Id = "WinMTR.WinMTR"; Name = "WinMTR" }
)

# ----------------------------
# Developer / Ops / CLI Tools
# ----------------------------
$DevOps = @(
  @{ Id = "Microsoft.PowerShell"; Name = "PowerShell 7" },
  @{ Id = "Amazon.AWSCLI"; Name = "AWS CLI" }
)

# ----------------------------
# Windows Enhancements & Productivity
# ----------------------------
$Productivity = @(
  @{ Id = "Microsoft.PowerToys"; Name = "Microsoft PowerToys" },
  @{ Id = "FilesCommunity.Files"; Name = "Files App" },
  @{ Id = "voidtools.Everything"; Name = "Everything" },
  @{ Id = "stnkl.EverythingToolbar"; Name = "Everything Toolbar" },
  @{ Id = "Open-Shell.Open-Shell-Menu"; Name = "Open-Shell Menu" },
  @{ Id = "RamenSoftware.Windhawk"; Name = "Windhawk" },

  @{ Id = "Winaero.WinaeroTweaker"; Name = "Winaero Tweaker" },
  @{ Id = "AltSnap.AltSnap"; Name = "AltSnap" },

  @{ Id = "DupeGuru.DupeGuru"; Name = "dupeGuru" },
  @{ Id = "WinMerge.WinMerge"; Name = "WinMerge" },
  @{ Id = "WinDirStat.WinDirStat"; Name = "WinDirStat" },
  @{ Id = "AntibodySoftware.WizTree"; Name = "WizTree" },
  @{ Id = "QL-Win.QuickLook"; Name = "QuickLook" }
)

# ----------------------------
# Privacy & Security
# ----------------------------
$Security = @(
  @{ Id = "AndyFul.ConfigureDefender"; Name = "ConfigureDefender" },
  @{ Id = "Henry++.Simplewall"; Name = "simplewall" }
)

# ----------------------------
# Media, Content Tools & Creativity
# ----------------------------
$Media = @(
  @{ Id = "VideoLAN.VLC"; Name = "VLC media player" },
  @{ Id = "dotPDN.PaintDotNet"; Name = "Paint.NET" },
  @{ Id = "ShareX.ShareX"; Name = "ShareX" },
  @{ Id = "OBSProject.OBSStudio"; Name = "OBS Studio" },

  @{ Id = "Meltytech.Shotcut"; Name = "Shotcut" },
  @{ Id = "HandBrake.HandBrake"; Name = "HandBrake" },
  @{ Id = "Audacity.Audacity"; Name = "Audacity" },
  @{ Id = "AndreWiethoff.ExactAudioCopy"; Name = "Exact Audio Copy" },
  @{ Id = "MusicBrainz.Picard"; Name = "MusicBrainz Picard" },

  @{ Id = "IrfanSkiljan.IrfanView"; Name = "IrfanView" },
  @{ Id = "KDE.Krita"; Name = "Krita" },
  @{ Id = "BlenderFoundation.Blender"; Name = "Blender" },

  @{ Id = "MKVToolNix.MKVToolNix"; Name = "MKVToolNix" },
  @{ Id = "MediaArea.MediaInfo.GUI"; Name = "MediaInfo" },
  @{ Id = "GuinpinSoft.MakeMKV"; Name = "MakeMKV" },
  @{ Id = "Canneverbe.CDBurnerXP"; Name = "CDBurnerXP" }
)

# ----------------------------
# Backup, Imaging & Boot Media
# ----------------------------
$BackupImaging = @(
  @{ Id = "Rescuezilla.Rescuezilla"; Name = "Rescuezilla" },
  @{ Id = "Rufus.Rufus"; Name = "Rufus" },
  @{ Id = "Ventoy.Ventoy"; Name = "Ventoy" }
)
# Macrium Reflect: manual install (licensing/distribution varies)

# ----------------------------
# Cloud / S3 Tooling
# ----------------------------
$Cloud = @(
  @{ Id = "Rclone.Rclone"; Name = "rclone" },
  @{ Id = "Bdrive.RcloneView"; Name = "Rclone Browser (RcloneView)" },
  @{ Id = "Netsdk.S3Browser"; Name = "S3 Browser" }
)

# ----------------------------
# Gaming / GPU Benchmarks
# ----------------------------
$GamingBench = @(
  @{ Id = "Valve.Steam"; Name = "Steam" },
  @{ Id = "Unigine.HeavenBenchmark"; Name = "Unigine Heaven" },
  @{ Id = "Unigine.SuperpositionBenchmark"; Name = "Unigine Superposition" }
)

# ========= RUN INSTALLS =========
$AllGroups = @(
  @{ Title="Browsers"; Items=$Browsers },
  @{ Title="System Essentials & Hardware Control"; Items=$SystemEssentials },
  @{ Title="Networking & Diagnostics"; Items=$Networking },
  @{ Title="Developer / Ops / CLI Tools"; Items=$DevOps },
  @{ Title="Windows Enhancements & Productivity"; Items=$Productivity },
  @{ Title="Privacy & Security"; Items=$Security },
  @{ Title="Media, Content Tools & Creativity"; Items=$Media },
  @{ Title="Backup, Imaging & Boot Media"; Items=$BackupImaging },
  @{ Title="Cloud / S3 Tooling"; Items=$Cloud },
  @{ Title="Gaming / GPU Benchmarks"; Items=$GamingBench }
)

foreach ($group in $AllGroups) {
  Write-Host "`n============================" -ForegroundColor Yellow
  Write-Host $group.Title -ForegroundColor Yellow
  Write-Host "============================" -ForegroundColor Yellow

  foreach ($pkg in $group.Items) {
    Install-WinGetPackage -Id $pkg.Id -Name $pkg.Name
  }
}

Write-Host "`nDone. Suggest rebooting if shell components (.NET/Explorer tweaks) or services were installed." -ForegroundColor Green
