@echo off

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
    echo ERROR: SourceCodePath is not defined in config.bat
    pause
    exit /b 1
)

if not defined ProjectPureName (
    echo ERROR: ProjectPureName is not defined in config.bat
    pause
    exit /b 1
)

if not defined ProjectRoot (
    echo ERROR: ProjectRoot is not defined in config.bat
    pause
    exit /b 1
)


:begin

set "TestClassName="
set "TestRelativePath="
set "UserConfirmed="

set /p "TestClassName=Enter test class name: "

if not defined TestClassName (
    echo Test class name cannot be empty.
    echo.
    goto :begin
)

set /p "TestRelativePath=Enter relative to [Source\%ProjectPureName%\Private or Public] directory (use \ for subdirs): "

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

set "TestAbsoluteDir=%SourceCodePath%\%ProjectPureName%"

if defined TestRelativePath (
    set "TestCppDir=%TestAbsoluteDir%\Private\%TestRelativePath%"
    set "TestHDir=%TestAbsoluteDir%\Public\%TestRelativePath%"

    set "TempPath=%TestRelativePath%\%TestClassName%.h"
) else (
    set "TestCppDir=%TestAbsoluteDir%\Private"
    set "TestHDir=%TestAbsoluteDir%\Public"

    set "TempPath=%TestClassName%.h"
)

set "TestCppFileName=%TestClassName%.cpp"
set "TestHFileName=%TestClassName%.h"

set "TestCppFilePath=%TestCppDir%\%TestCppFileName%"
set "TestHFilePath=%TestHDir%\%TestHFileName%"


rem ============================================================
rem Template paths
rem ============================================================

set "TestCppTemplateFilePath=%ProjectRoot%\UEDevOps\tests\templates\Test.cpp.template"
set "TestHTemplateFilePath=%ProjectRoot%\UEDevOps\tests\templates\Test.h.template"

if not exist "%TestCppTemplateFilePath%" (
    echo.
    echo ERROR: C++ template was not found:
    echo %TestCppTemplateFilePath%
    pause
    exit /b 1
)

if not exist "%TestHTemplateFilePath%" (
    echo.
    echo ERROR: Header template was not found:
    echo %TestHTemplateFilePath%
    pause
    exit /b 1
)


rem ============================================================
rem Variables used inside template files
rem ============================================================

rem Convert backslashes to forward slashes for #include
set TEST_INCLUDE_FILE="%TempPath:\=/%"

rem Escaped characters for template files
set "OR=^|"
set "AND=^&"


rem ============================================================
rem Confirmation
rem ============================================================

echo.
echo =========== Files to be created ===========
echo %TestCppFilePath%
echo %TestHFilePath%
echo ===========================================
echo.

set /p "UserConfirmed=Confirm? [Y/N or (E)xit]: "

if /I "%UserConfirmed%"=="N" goto :begin
if /I "%UserConfirmed%"=="E" goto :EOF

if /I not "%UserConfirmed%"=="Y" (
    echo Unknown option.
    echo.
    goto :begin
)


rem ============================================================
rem Create directories
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

if not exist "%TestHDir%\" (
    mkdir "%TestHDir%"

    if errorlevel 1 (
        echo.
        echo ERROR: Failed to create directory:
        echo %TestHDir%
        pause
        exit /b 1
    )
)


rem ============================================================
rem Remove old files if they already exist
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

if exist "%TestHFilePath%" (
    del /q "%TestHFilePath%"

    if errorlevel 1 (
        echo.
        echo ERROR: Failed to remove existing file:
        echo %TestHFilePath%
        pause
        exit /b 1
    )
)


rem ============================================================
rem Create files from templates
rem ============================================================

call :createTemplate "%TestCppTemplateFilePath%" "%TestCppFilePath%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to create:
    echo %TestCppFilePath%
    pause
    exit /b 1
)

call :createTemplate "%TestHTemplateFilePath%" "%TestHFilePath%"

if errorlevel 1 (
    echo.
    echo ERROR: Failed to create:
    echo %TestHFilePath%
    pause
    exit /b 1
)


echo.
echo Files successfully created:
echo %TestCppFilePath%
echo %TestHFilePath%
echo.


rem ============================================================
rem Run clang-format
rem ============================================================

if exist "%~dp0..\misc\format_all_files.bat" (
    call "%~dp0..\misc\format_all_files.bat"
) else (
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
    echo ERROR: Template file does not exist:
    echo %TemplateName%
    exit /b 1
)

rem Create an empty destination file
type nul > "%FileToWriteIn%"

if errorlevel 1 (
    echo ERROR: Cannot create file:
    echo %FileToWriteIn%
    exit /b 1
)

rem Read template and expand template variables
for /f "usebackq delims=" %%a in ("%TemplateName%") do (
    if %%a == NEW_LINE (
        echo.>>"%FileToWriteIn%"
    ) else (
        call echo %%a>>"%FileToWriteIn%"
    )
)