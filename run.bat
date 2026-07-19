@echo off
setlocal enabledelayedexpansion

set "REPO_URL=https://github.com/Lifantel/ytcli.git"
set "INSTALL_DIR=%LOCALAPPDATA%\ytcli"
set "VENV_DIR=%INSTALL_DIR%\venv"

echo === ytcli kurulum scripti (Windows) ===

where winget >nul 2>nul
if errorlevel 1 (
    echo HATA: winget bulunamadi. Lutfen App Installer'i Microsoft Store'dan kurun.
    exit /b 1
)

echo [1/5] Python kontrol ediliyor...
where python >nul 2>nul
if errorlevel 1 (
    echo Python bulunamadi, kuruluyor...
    winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements
) else (
    echo Python zaten kurulu.
)

echo [2/5] Git kontrol ediliyor...
where git >nul 2>nul
if errorlevel 1 (
    echo Git bulunamadi, kuruluyor...
    winget install -e --id Git.Git --accept-source-agreements --accept-package-agreements
) else (
    echo Git zaten kurulu.
)

echo [3/5] mpv kontrol ediliyor...
where mpv >nul 2>nul
if errorlevel 1 (
    echo mpv bulunamadi, kuruluyor...
    winget install -e --id shinchiro.mpv --accept-source-agreements --accept-package-agreements
) else (
    echo mpv zaten kurulu.
)

echo [4/5] Repo klonlaniyor...
if exist "%INSTALL_DIR%\.git" (
    echo Repo zaten mevcut, guncelleniyor...
    git -C "%INSTALL_DIR%" pull
) else (
    if exist "%INSTALL_DIR%" rmdir /s /q "%INSTALL_DIR%"
    git clone "%REPO_URL%" "%INSTALL_DIR%"
)

echo [5/5] Sanal ortam olusturuluyor ve bagimliliklar kuruluyor...
if not exist "%VENV_DIR%" (
    python -m venv "%VENV_DIR%"
)

call "%VENV_DIR%\Scripts\activate.bat"

pip install --upgrade pip

if exist "%INSTALL_DIR%\requirements.txt" (
    pip install -r "%INSTALL_DIR%\requirements.txt"
) else (
    pip install yt-dlp
)

echo ytcli baslatiliyor...
python "%INSTALL_DIR%\src\ytcli.py"

call "%VENV_DIR%\Scripts\deactivate.bat"

endlocal
