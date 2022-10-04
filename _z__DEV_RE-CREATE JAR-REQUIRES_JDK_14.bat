@echo off
setlocal
call :checkifrightdir

rem ------- custom variables ------
echo  SETTING CUSTOM VARIABLES

SET javamemory=-Xms512m


SET finaljarname=RuneLite.jar
SET runelitedir=C:\Users\%USERNAME%\.runelite
SET JAVAPATHH="C:\Program Files\Java\jdk-14\bin\javaw.exe"
SET JARPATHH="C:\Program Files\Java\jdk-14\bin\jar.exe"
SET tempjarname=CreatedRuneLite.jar

IF NOT EXIST %JAVAPATHH% goto nojava


rem ------- variables you do not edit ------
echo  SETTING VARIABLES
SET tempmanifest=MANIFEST.MF
SET thisdir=%CD%
SET outfile=%thisdir%\%tempmanifest%
SET CLASSTORUN=com.

rem ----------- clear all files before creating them ----------- 
echo  DELETING OLD FILES
del "%thisdir%\%tempmanifest%"
del "%thisdir%\CreateShortcut.vbs"
del "%thisdir%\%tempjarname%"

rem ------- EDIT THIS IF YOU CHAGED THE FOLDER STRUCTURE ----------
rem ------- EDIT THIS IF YOU CHAGED THE FOLDER STRUCTURE  >>>>>>>

rem ----------- finding the classfiles and creating manifest------------
rem ------------- this looks for the main class to startup >>>>>>>>>>
echo  LOOKING FOR MAIN CLASS FILE

%thisdir:~0,2%
cd "%thisdir%\build\classes\java\test\com\"
rem <<<<<<<<<<<<<<<< this looks for the main class to startup ----------

for /d %%d in (*.*) do (
	call SET bb=%%d;
	call SET CLASSTORUN=%%CLASSTORUN%%%%~nxd.
)
%thisdir:~0,2%
cd "%thisdir%"
%bb:~0,2%
cd "%bb%"
for /R %%F IN (*.class) DO (
SET filename=%%~nxF
)

%thisdir:~0,2%
cd "%thisdir%"
SET CLASSTORUN=%CLASSTORUN%%filename:~0,-6%

rem ------- write the manifest to disk ---------
echo  CREATING MANIFEST
echo Manifest-Version: 1.0 >> "%outfile%"
echo Main-Class: %CLASSTORUN% >> "%outfile%"
echo Class-Path: >> "%outfile%"
%runelitedir:~0,2%
	cd "%runelitedir%\repository2"
		for /R %%f in (*.jar) do (
				echo  repository2/%%~nxf >> "%outfile%"
		)
%thisdir:~0,2%
	cd "%thisdir%"
echo Created-By: 14 (Oracle Corporation) >> "%outfile%"


rem ----------- packing jar -----------
mkdir jar_temp_folder
cd jar_temp_folder
mkdir com
cd com

rem ------- EDIT THIS IF YOU CHAGED THE FOLDER STRUCTURE ----------
rem ------- EDIT THIS IF YOU CHAGED THE FOLDER STRUCTURE  >>>>>>>
echo  COPYING CLASSES TO TEMP
xcopy ..\..\build\classes\java\test\* . /E /H /C /I
xcopy ..\..\build\classes\java\main\* . /E /H /C /I

rem <<<<<<< EDIT THIS IF YOU CHAGED THE FOLDER STRUCTURE ----------
rem <<<<<<< EDIT THIS IF YOU CHAGED THE FOLDER STRUCTURE ----------

echo  CREATING JAR WITH CLASSES AND MANIFEST
%JARPATHH% cvfm ..\..\%tempjarname% ..\..\MANIFEST.MF *
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
%thisdir:~0,2%
cd "%thisdir%"

rem ----------- copying jar to runelite dir -----------
echo  DELETING OLD JAR IN RUNELITE DIR
IF EXIST "%thisdir%\%tempjarname%" del "%runelitedir%\%finaljarname%"
echo  PLACING JAR IN RUNELITE DIR

move "%tempjarname%" "%runelitedir%\%finaljarname%"

echo #########################################################
echo #########################################################
echo #########################################################
echo #########################################################
echo - SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS!
echo #########################################################
echo #########################################################
echo - SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS!
echo #########################################################
echo #########################################################
echo - SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS!
echo #########################################################
echo #########################################################
echo ^ - 
echo    your jar is located in %runelitedir%
echo    Re-Run this setup after you have edited and compiled this plugin
echo ^ -
echo #########################################################
echo #########################################################
echo - SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS!
echo #########################################################
echo #########################################################
echo - SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS!
echo #########################################################
echo #########################################################
echo - SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS! SUCCESS!
echo #########################################################
echo #########################################################



pause
%jar_temp_folder:~0,2%
cd %jar_temp_folder%
rmdir com
cd ..
rmdir %jar_temp_folder%

exit



:nojava
echo - can not find %JAVAPATHH%
echo - INSTALL JDK 14 OR run INSTALL WITHOUT JARRING.bat to install without jarring (you need to keep this folder)
pause
exit
 
:checkifrightdir
IF NOT EXIST build\classes\java (
echo #########################################################
echo #########################################################
echo #########################################################
echo - FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!!
echo - FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!!
echo #########################################################
echo #########################################################
echo -
echo   DID YOU BUILD YOUR PLUGIN CORRECTLY IN INTELLIJ?
echo   YOU NEED TO BUILD YOUR PLUGIN IF IT IS NOT DONE YET
echo   YOU NEED TO PUT THIS FILE IN THE THE ROOT OF YOUR PLUGIN
echo   THIS FILE SEARCHES FOR build\classes\java
echo -
echo #########################################################
echo #########################################################
echo - FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!!
echo - FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!! FAIL!!
echo #########################################################
echo #########################################################
pause
exit
)


