@echo off

:: Preguntar si quiere hacer git clean
set CLEAN_CHOICE=
set /p CLEAN_CHOICE="Quieres borrar archivos no identicos (solo hacer si te crashea el minecraft)? (s/n): "

:: Preparar flag según respuesta
if /I "%CLEAN_CHOICE%"=="s" (
    set DO_CLEAN=1
) else (
    set DO_CLEAN=0
)

:: Comprobar si Git está instalado
where git >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Git no esta instalado. Instalando Git...

    :: Comprobar si winget existe
    where winget >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        winget install --id Git.Git -e --source winget
    ) else (
        echo Winget no esta disponible.
        echo Instala Git manualmente desde:
        echo https://git-scm.com/download/win
        pause
        exit /b
    )
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$remote='https://github.com/MarioG-55/MP_PepoServer';" ^
    "if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host 'Git no está instalado'; exit 1 };" ^
    "if (-not (Test-Path '.git')) { Write-Host 'Inicializando nuevo repo...'; git init; git remote add origin $remote }" ^
    "else { if (-not ((git remote) -contains 'origin')) { git remote add origin $remote } };" ^
    "git fetch --all;" ^
    "git reset --hard origin/main;" ^
    "if (%DO_CLEAN% -eq 1) { Write-Host 'Ejecutando git clean -fd...'; git clean -fd } else { Write-Host 'Saltando git clean.' };" ^
    "Write-Host 'Repositorio sincronizado. Yippie';"

pause