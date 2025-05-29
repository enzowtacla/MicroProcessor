@echo off
setlocal enabledelayedexpansion

rem Procurar arquivos .vhd na pasta atual
for %%f in (*.vhd) do (
    set "filename=%%~nf"
    
    echo.
    echo === Processando: !filename!.vhd ===

    rem Análise
    ghdl -a "!filename!.vhd"
    if errorlevel 1 (
        echo [ERRO] na análise de !filename!.vhd
        pause
        exit /b
    )

    rem Elaboração
    ghdl -e "!filename!"
    if errorlevel 1 (
        echo [ERRO] na elaboração de !filename!
        pause
        exit /b
    )

    rem Execução + geração de waveform
    ghdl -r "!filename!" --wave="!filename!.ghw"
    if errorlevel 1 (
        echo [ERRO] na simulação de !filename!
        pause
        exit /b
    )

    rem Abrir no GTKWave
    start gtkwave "!filename!.ghw"
)

echo.
echo Processo finalizado.
pause
Exit