@echo off
chcp 65001 >nul
echo ===== LIMPEZA DE ARQUIVOS TEMPORARIOS =====

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-PSDrive C).Free/1GB,2)"`) do set ANTES=%%a
echo Espaco livre em C: antes: %ANTES% GB

echo Limpando pasta temporaria do usuario...
del /q /f /s "%TEMP%\*" >nul 2>&1
for /d %%d in ("%TEMP%\*") do rd /s /q "%%d" >nul 2>&1

echo Limpando C:\Windows\Temp (requer administrador)...
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1

echo Limpando cache DNS...
ipconfig /flushdns >nul

echo Esvaziando a lixeira...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue"

for /f "usebackq delims=" %%a in (`powershell -NoProfile -Command "[math]::Round((Get-PSDrive C).Free/1GB,2)"`) do set DEPOIS=%%a
echo Espaco livre em C: depois: %DEPOIS% GB
echo Concluido.
pause
