@echo off
echo ========================================
echo Fiber Splice Manager - Windows Build
echo ========================================
echo.

echo Step 1: Building frontend and backend...
call npm run build
if %ERRORLEVEL% NEQ 0 (
    echo Error: Build failed
    pause
    exit /b 1
)

echo.
echo Step 2: Building Windows executable...
call npx electron-builder --win --x64 --config electron-builder.yml
if %ERRORLEVEL% NEQ 0 (
    echo Error: Electron build failed
    echo.
    echo Make sure you have moved electron and electron-builder
    echo from dependencies to devDependencies in package.json
    pause
    exit /b 1
)

echo.
echo ========================================
echo Build completed successfully!
echo.
echo Your executable can be found in:
echo   release\Fiber Splice Manager Setup x.x.x.exe
echo or
echo   release\win-unpacked\Fiber Splice Manager.exe
echo ========================================
pause
