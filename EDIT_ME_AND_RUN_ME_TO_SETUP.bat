@echo off
setlocal
call :checkifrightdir

rem ------- custom variables ------
echo  SETTING CUSTOM VARIABLES

SET javamemory=-Xms512m


SET finaljarname=RuneLite.jar
SET runelitedir=C:\Users\%USERNAME%\.runelite
SET JAVAPATHH=C:\Users\%USERNAME%\AppData\Local\RuneLite\jre\bin\javaw.exe
rem SET JAVAPATHH="C:\Program Files\Java\jdk-14\bin\javaw.exe"
SET tempjarname=CreatedRuneLite.jar

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
cd "%thisdir%\build\classes\java\test\com\"
rem <<<<<<<<<<<<<<<< this looks for the main class to startup ----------

for /d %%d in (*.*) do (
call SET bb=%%d;
call SET CLASSTORUN=%%CLASSTORUN%%%%~nxd.
)
cd "%thisdir%"
cd "%bb%"
for /R %%F IN (*.class) DO (
SET filename=%%~nxF
)
cd "%thisdir%"
SET CLASSTORUN=%CLASSTORUN%%filename:~0,-6%

rem ------- write the manifest to disk ---------
echo  CREATING MANIFEST
echo Manifest-Version: 1.0 >> "%outfile%"
echo Main-Class: %CLASSTORUN% >> "%outfile%"
echo Class-Path: >> "%outfile%"
	cd "%runelitedir%\repository2"
		for /R %%f in (*.jar) do (
				echo  repository2/%%~nxf >> "%outfile%"
		)
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
jar cvfm ..\..\%tempjarname% ..\..\MANIFEST.MF *
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)
cd "%thisdir%"

rem ----------- copying jar to runelite dir -----------
echo  DELETING OLD JAR IN RUNELITE DIR
IF EXIST "%thisdir%\%tempjarname%" del "%runelitedir%\%finaljarname%"
echo  PLACING JAR IN RUNELITE DIR

move "%tempjarname%" "%runelitedir%\%finaljarname%"
echo  your jar is located in %runelitedir%
del "%thisdir%\RuneLite.lnk" 
rem ----------- create shortcut script in this directory ------------
echo  Creating script to make shortcuts to the new jar
@(  echo SET WshShell = WScript.CreateObject("WScript.Shell"^)
    echo SET oShellLink = WshShell.CreateShortcut("%thisdir%\RuneLite.lnk"^)
    echo oShellLink.TargetPath = """%JAVAPATHH%"""
    echo oShellLink.WindowStyle = 1
    echo oShellLink.Hotkey = "CTRL+SHIFT+R"
    echo oShellLink.IconLocation = "C:\Users\%USERNAME%\AppData\Local\RuneLite\RuneLite.exe, 0"
    echo oShellLink.Description = "RuneLite"
    echo oShellLink.WorkingDirectory = "%runelitedir%"
	echo oShellLink.Arguments = "%javamemory% -jar -Duser.variant -ea %runelitedir%\%finaljarname%"
	echo oShellLink.Save) 1>"%thisdir%\CreateShortcut.vbs"
@%SystemRoot%\System32\cscript.exe //NoLogo "%thisdir%\CreateShortcut.vbs"

rem ----------- create shortcuts ------------
rem ----------- backup the runelite.lnk files and place the edited ones -----------
SET startmenu=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
SET desktopp=C:\Users\%USERNAME%\Desktop
mkdir backup

rem mkdir "%startmenu%\RuneLite"
rem IF NOT EXIST "%startmenu%\RuneLite\RuneLite.lnk.back" move "%startmenu%\RuneLite.lnk" "%startmenu%\RuneLite\RuneLite.lnk.back"
IF NOT EXIST backup\RuneLite.lnk move "%desktopp%\RuneLite.lnk" backup
echo  Copying the new shortcuts to desktop and start folder
move RuneLite.lnk "%startmenu%"
@%SystemRoot%\System32\cscript.exe //NoLogo "%thisdir%\CreateShortcut.vbs"
move RuneLite.lnk "C:\Users\%USERNAME%\Desktop"
@%SystemRoot%\System32\cscript.exe //NoLogo "%thisdir%\CreateShortcut.vbs"


rem ----------- cleanup -----------
echo  Cleaning up
del "%thisdir%\CreateShortcut.vbs"
del "%thisdir%\%tempmanifest%"





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
echo    The runelite shortcuts have been changed.
echo    You can just open runelite like normal
echo    Runelite will now include this plugin
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
cd jar_temp_folder
rmdir com
cd ..
rmdir jar_temp_folder

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