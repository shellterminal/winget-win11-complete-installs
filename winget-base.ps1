# Win11 Baseline Setup - winget installer
# Run in an elevated PowerShell 7+ session if possible.

$ErrorActionPreference = "Stop"

function Assert-WinGet {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    throw "winget not found. Install 'App Installer' from Microsoft Store, then re-run."
  }
}

function Install-WinGetPackage {
  param(
    [Parameter(Mandatory=$true)][string]$Id,
    [string]$Name = $Id
  )

  Write-Host "`n==> Installing: $Name ($Id)" -ForegroundColor Cyan

  # Common flags:
  # -e / --exact reduces ambiguity
  # --accept-* avoids prompts
  # --disable-interactivity keeps it scriptable
  # --silent works for many packages; if a package doesn't support silent, winget may still proceed or fail.
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

Assert-WinGet

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
# Windows Enhancements & Productivity
# ----------------------------
$Productivity = @(
  @{ Id = "Microsoft.PowerToys"; Name = "Microsoft PowerToys" },
  @{ Id = "FilesCommunity.Files"; Name = "Files App" },                     # from your list
  @{ Id = "voidtools.Everything"; Name = "Everything" },                    # from your list
  @{ Id = "stnkl.EverythingToolbar"; Name = "Everything Toolbar" },         # from your list
  @{ Id = "Open-Shell.Open-Shell-Menu"; Name = "Open-Shell Menu" },         # from your list
  @{ Id = "RamenSoftware.Windhawk"; Name = "Windhawk" },                    # from your list

  @{ Id = "Winaero.WinaeroTweaker"; Name = "Winaero Tweaker" },
  @{ Id = "AltSnap.AltSnap"; Name = "AltSnap" },

  @{ Id = "DupeGuru.DupeGuru"; Name = "dupeGuru" },
  @{ Id = "WinMerge.WinMerge"; Name = "WinMerge" },                         # from your list
  @{ Id = "WinDirStat.WinDirStat"; Name = "WinDirStat" },                   # from your list
  @{ Id = "AntibodySoftware.WizTree"; Name = "WizTree" },
  @{ Id = "QL-Win.QuickLook"; Name = "QuickLook" }
)

# ----------------------------
# Privacy & Security
# ----------------------------
$Security = @(
  @{ Id = "AndyFul.ConfigureDefender"; Name = "ConfigureDefender" },         # from your list
  @{ Id = "Henry++.Simplewall"; Name = "simplewall" }
)

# ----------------------------
# Media, Content Tools & Creativity
# ----------------------------
$Media = @(
  @{ Id = "VideoLAN.VLC"; Name = "VLC media player" },                       # from your list
  @{ Id = "dotPDN.PaintDotNet"; Name = "Paint.NET" },
  @{ Id = "ShareX.ShareX"; Name = "ShareX" },                                # from your list
  @{ Id = "OBSProject.OBSStudio"; Name = "OBS Studio" },

  @{ Id = "Meltytech.Shotcut"; Name = "Shotcut" },                           # from your list
  @{ Id = "HandBrake.HandBrake"; Name = "HandBrake" },
  @{ Id = "Audacity.Audacity"; Name = "Audacity" },                          # from your list
  @{ Id = "AndreWiethoff.ExactAudioCopy"; Name = "Exact Audio Copy" },       # from your list
  @{ Id = "MusicBrainz.Picard"; Name = "MusicBrainz Picard" },

  @{ Id = "IrfanSkiljan.IrfanView"; Name = "IrfanView" },
  @{ Id = "KDE.Krita"; Name = "Krita" },
  @{ Id = "BlenderFoundation.Blender"; Name = "Blender" },

  @{ Id = "MKVToolNix.MKVToolNix"; Name = "MKVToolNix" },
  @{ Id = "MediaArea.MediaInfo.GUI"; Name = "MediaInfo" },                   # from your list
  @{ Id = "GuinpinSoft.MakeMKV"; Name = "MakeMKV" },
  @{ Id = "Canneverbe.CDBurnerXP"; Name = "CDBurnerXP" }
)

# ----------------------------
# Backup, Imaging & Boot Media
# ----------------------------
$BackupImaging = @(
  @{ Id = "Rescuezilla.Rescuezilla"; Name = "Rescuezilla" },
  @{ Id = "Rufus.Rufus"; Name = "Rufus" },                                   # from your list
  @{ Id = "Ventoy.Ventoy"; Name = "Ventoy" }
)
# NOTE: Macrium Reflect is intentionally not scripted here (varies by licensing / distribution).
# You said you use it for older machines — keep it as a manual install.

# ----------------------------
# Cloud / S3 Tooling
# ----------------------------
$Cloud = @(
  @{ Id = "Rclone.Rclone"; Name = "rclone" },                                # from your list
  @{ Id = "Bdrive.RcloneView"; Name = "Rclone Browser (RcloneView)" },       # GUI rclone browser shown in your list
  @{ Id = "Netsdk.S3Browser"; Name = "S3 Browser" }                          # from your list
)

# ----------------------------
# Gaming / GPU Ecosystem + Benchmarks
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

Write-Host "`nDone. Suggest rebooting if drivers/tools hooked system services or shell components." -ForegroundColor Green
