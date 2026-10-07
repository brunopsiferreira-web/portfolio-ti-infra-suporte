@echo off
chcp 65001 >nul
setlocal

:: Nome do arquivo: diagnostico_PC_AAAAMMDD_HHMM.txt (formato de data pt-BR)
set DATA=%date:~-4%%date:~3,2%%date:~0,2%
set HORA=%time:~0,2%%time:~3,2%
set HORA=%HORA: =0%
set ARQ=diagnostico_%COMPUTERNAME%_%DATA%_%HORA%.txt

:: Descobre o gateway padrao
set GW=
for /f "tokens=3" %%a in ('route print -4 0.0.0.0 ^| findstr /R /C:"^ *0\.0\.0\.0  *0\.0\.0\.0"') do (
    if not defined GW set GW=%%a
)

echo Gerando diagnostico em %ARQ% ... aguarde.

echo ===== DIAGNOSTICO DE REDE ===== > "%ARQ%"
echo Computador: %COMPUTERNAME% >> "%ARQ%"
echo Usuario: %USERNAME% >> "%ARQ%"
echo Data/Hora: %date% %time% >> "%ARQ%"
echo Gateway detectado: %GW% >> "%ARQ%"

echo. >> "%ARQ%" & echo ===== IPCONFIG /ALL ===== >> "%ARQ%"
ipconfig /all >> "%ARQ%"

echo. >> "%ARQ%" & echo ===== PING GATEWAY (%GW%) ===== >> "%ARQ%"
if defined GW (ping -n 4 %GW% >> "%ARQ%") else (echo Gateway nao encontrado >> "%ARQ%")

echo. >> "%ARQ%" & echo ===== PING INTERNET POR IP (8.8.8.8) ===== >> "%ARQ%"
ping -n 4 8.8.8.8 >> "%ARQ%"

echo. >> "%ARQ%" & echo ===== PING POR NOME (google.com) ===== >> "%ARQ%"
ping -n 4 google.com >> "%ARQ%"

echo. >> "%ARQ%" & echo ===== NSLOOKUP ===== >> "%ARQ%"
nslookup google.com >> "%ARQ%"

echo. >> "%ARQ%" & echo ===== TRACERT (max 10 saltos) ===== >> "%ARQ%"
tracert -d -h 10 8.8.8.8 >> "%ARQ%"

echo. >> "%ARQ%" & echo ===== TABELA ARP ===== >> "%ARQ%"
arp -a >> "%ARQ%"

echo.
echo Concluido! Arquivo salvo: %ARQ%
pause
