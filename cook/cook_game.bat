@echo off

call "%~dp0..\..\devops_data\config.bat"

"%RunUATPath%" ^
BuildCookRun ^
-project="%ProjectPath%" ^
-platform=%Platform% ^
-clientconfig=%Configuration% ^
-build -cook -skippackage 