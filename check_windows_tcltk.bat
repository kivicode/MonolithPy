@echo off
REM Diagnostic script to check Tcl/Tk externals on Windows

echo ========================================
echo Checking Tcl/Tk Externals
echo ========================================
echo.

set TCLTK_DIR=externals\tcltk-8.6.15.0\amd64

if not exist "%TCLTK_DIR%" (
    echo ERROR: %TCLTK_DIR% does not exist!
    echo Please run: cd PCbuild ^&^& call get_externals.bat
    goto :error
)

echo Checking %TCLTK_DIR%\bin...
dir "%TCLTK_DIR%\bin" /b 2>nul
if %errorlevel% neq 0 (
    echo ERROR: bin directory is empty or missing!
) else (
    echo OK: bin directory exists
)
echo.

echo Checking %TCLTK_DIR%\lib...
if not exist "%TCLTK_DIR%\lib" (
    echo ERROR: lib directory does not exist!
    goto :error
)

dir "%TCLTK_DIR%\lib" /b 2>nul
if %errorlevel% neq 0 (
    echo ERROR: lib directory is empty!
    goto :error
)

echo.
echo Checking for required lib files...
set MISSING=0

if not exist "%TCLTK_DIR%\lib\tcl86t.lib" (
    echo MISSING: tcl86t.lib
    set MISSING=1
)
if not exist "%TCLTK_DIR%\lib\tk86t.lib" (
    echo MISSING: tk86t.lib
    set MISSING=1
)

if %MISSING% equ 1 (
    echo.
    echo ERROR: Required .lib files are missing!
    echo The externals download may be incomplete.
    echo.
    echo Try: cd PCbuild ^&^& call get_externals.bat --clean ^&^& call get_externals.bat
    goto :error
) else (
    echo OK: All required .lib files found
)

echo.
echo Checking for DLL files in lib...
dir "%TCLTK_DIR%\lib\*.dll" /b 2>nul
if %errorlevel% equ 0 (
    echo OK: DLL files found in lib directory
) else (
    echo Note: No DLL files in lib directory (they may be in bin)
)

echo.
echo ========================================
echo Summary: Tcl/Tk externals appear OK
echo ========================================
exit /b 0

:error
echo.
echo ========================================
echo Summary: Tcl/Tk externals have issues!
echo ========================================
exit /b 1
