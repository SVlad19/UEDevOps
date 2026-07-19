@echo off
setlocal EnableExtensions DisableDelayedExpansion

rem Load project configuration
call "%~dp0..\..\devops_data\config.bat"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to load config.bat
    pause
    exit /b 1
)

rem Check required variables from config.bat
if not defined SourceCodePath (
    echo.
    echo ERROR: SourceCodePath is not defined in config.bat
    pause
    exit /b 1
)

if not defined ProjectPureName (
    echo.
    echo ERROR: ProjectPureName is not defined in config.bat
    pause
    exit /b 1
)

if not defined ProjectRoot (
    echo.
    echo ERROR: ProjectRoot is not defined in config.bat
    pause
    exit /b 1
)


:begin

rem Clear values in case the user returns here with goto
set "TestClassName="
set "TestRelativePath="
set "UserConfirmed="

set /p "TestClassName=Enter test class name (without word 'Test' in the name): "

if not defined TestClassName (
    echo.
    echo Test class name cannot be empty.
    echo.
    goto :begin
)

set /p "TestRelativePath=Enter relative to [Source\%ProjectPureName%\Private] directory (use \ for subdirs): "


rem ============================================================
rem Normalize relative path
rem ============================================================

rem Remove leading backslash
if defined TestRelativePath (
    if "%TestRelativePath:~0,1%"=="\" (
        set "TestRelativePath=%TestRelativePath:~1%"
    )
)

rem Remove trailing backslash
if defined TestRelativePath (
    if "%TestRelativePath:~-1%"=="\" (
        set "TestRelativePath=%TestRelativePath:~0,-1%"
    )
)


rem ============================================================
rem File and directory paths
rem ============================================================

rem Module root:
rem Source\FPS_Test
set "TestAbsoluteDir=%SourceCodePath%\%ProjectPureName%"

rem Directory in which the .spec.cpp file will be created
if defined TestRelativePath (
    set "TestCppDir=%TestAbsoluteDir%\Private\%TestRelativePath%"
) else (
    set "TestCppDir=%TestAbsoluteDir%\Private"
)

rem .spec.cpp file name
set "TestCppFileName=%TestClassName%.spec.cpp"

rem Full path to the .spec.cpp file
set "TestCppFilePath=%TestCppDir%\%TestCppFileName%"


rem ============================================================
rem Template path
rem ============================================================

set "TestCppTemplateFilePath=%ProjectRoot%\UEDevOps\tests\templates\Test.spec.cpp.template"

if not exist "%TestCppTemplateFilePath%" (
    echo.
    echo ERROR: Template file was not found:
    echo %TestCppTemplateFilePath%
    pause
    exit /b 1
)


rem ============================================================
rem Template variables
rem ============================================================

set "OR=^|"
set "AND=^&"


rem ============================================================
rem Confirmation
rem ============================================================

echo.
echo =========== File to be created ===========
echo %TestCppFilePath%
echo ==========================================
echo.

set /p "UserConfirmed=Confirm? [Y/N or (E)xit]: "

if /I "%UserConfirmed%"=="N" goto :begin
if /I "%UserConfirmed%"=="E" goto :EOF

if /I not "%UserConfirmed%"=="Y" (
    echo.
    echo Unknown option.
    echo.
    goto :begin
)


rem ============================================================
rem Create target directory
rem ============================================================

if not exist "%TestCppDir%\" (
    mkdir "%TestCppDir%"

    if errorlevel 1 (
        echo.
        echo ERROR: Failed to create directory:
        echo %TestCppDir%
        pause
        exit /b 1
    )
)


rem ============================================================
rem Remove old file if it exists
rem ============================================================

if exist "%TestCppFilePath%" (
    del /q "%TestCppFilePath%"

    if errorlevel 1 (
        echo.
        echo ERROR: Failed to remove existing file:
        echo %TestCppFilePath%
        pause
        exit /b 1
    )
)


rem ============================================================
rem Create file from template
rem ============================================================

call :createTemplate "%TestCppTemplateFilePath%" "%TestCppFilePath%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to create file:
    echo %TestCppFilePath%
    pause
    exit /b 1
)

echo.
echo File successfully created:
echo %TestCppFilePath%
echo.


rem ============================================================
rem Run clang-format
rem ============================================================

if exist "%~dp0..\misc\format_all_files.bat" (
    call "%~dp0..\misc\format_all_files.bat"
) else (
    echo.
    echo WARNING: format_all_files.bat was not found:
    echo %~dp0..\misc\format_all_files.bat
)

echo.
pause
exit /b 0


rem ============================================================
rem Function: create file from template
rem
rem Arguments:
rem   %%1 - template file
rem   %%2 - destination file
rem ============================================================

:createTemplate

set "TemplateName=%~1"
set "FileToWriteIn=%~2"

if not exist "%TemplateName%" (
    echo.
    echo ERROR: Template file does not exist:
    echo %TemplateName%
    exit /b 1
)

rem Create an empty output file
type nul > "%FileToWriteIn%"

if errorlevel 1 (
    echo.
    echo ERROR: Cannot create output file:
    echo %FileToWriteIn%
    exit /b 1
)

rem Read the template line by line
for /f "usebackq delims=" %%a in ("%TemplateName%") do (
    if "%%a"=="NEW_LINE" (
        echo.>>"%FileToWriteIn%"
    ) else (
        call echo %%a>>"%FileToWriteIn%"
    )
)