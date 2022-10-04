@echo off 
rem ------- custom variables ------

SET outfilename=_runs_classes_with_runelite.bat

SET vbs_file_to_start_without_cmd_screen=__this_runs_the_bat_silent.vbs

SET reposetory=C:\Users\%USERNAME%\.runelite\repository2
SET JAVAPATHH="C:\Users\%USERNAME%\AppData\Local\RuneLite\jre\bin\javaw.exe"
rem SET JAVAPATHH="%JAVA_HOME%\bin\javaw.exe"
rem SET JAVAPATHH="C:\Program Files\Java\jdk-14\bin\javaw.exe"

IF NOT EXIST %JAVAPATHH% goto nojava

call :checkifrightdir

rem ------- variables you do not edit ------
SET thisdir=%CD%
SET outfile=%thisdir%\%outfilename%



rem ----------- clear all files before creating them ----------- 
del "%thisdir%\%outfilename%"


rem ----------- get the test class name ------------
SET CLASSTORUN=com.

%thisdir:~0,2%
	cd "%thisdir%\build\classes\java\test\com\*.*"
		for /d %%d in (*.*) do (
			call SET bb=%%d;
			call SET CLASSTORUN=%%CLASSTORUN%%%%~nxd.
		)
%thisdir:~0,2%
	cd "%thisdir%"
	cd "%bb%"
		for /R %%F IN (*.class) DO (
		 set filename=%%~nxF
		)
%thisdir:~0,2%
	cd "%thisdir%"
	
SET CLASSTORUN=%CLASSTORUN%%filename:~0,-6%



rem ----------- create string for batchfile ------------
SET outstring=%JAVAPATHH% -Xms512m -Dfile.encoding=windows-1252 -Duser.country=US -Duser.language=en -Duser.variant -ea -cp "

%thisdir:~0,2%
	cd "%thisdir%\build\classes\java\*.*"
		for /d %%d in (*.*) do (
			rem call  SET outstring=%%outstring%%%reposetory%\%%~nxf;
			call SET outstring=%%outstring%%%thisdir%\build\classes\java\%%d\;
		)
	cd "%thisdir%"
	
%reposetory:~0,2%

	cd "%reposetory%"
		for /R %%f in (*.jar) do (
			call SET outstring=%%outstring%%%reposetory%\%%~nxf;
		)
%thisdir:~0,2%	
	cd "%thisdir%"

call SET outstring=%%outstring%%" %CLASSTORUN% 
rem ----------- write strings to batchfile ------------

echo %outstring% >> "%outfile%"
echo created %outfilename% 




rem ----------- create silent batch runner ------------
echo Set WshShell = CreateObject("WScript.Shell") >> "%thisdir%\%vbs_file_to_start_without_cmd_screen%"
echo WshShell.Run chr(34) ^& "%outfilename%" ^& Chr(34), 0  >> "%thisdir%\%vbs_file_to_start_without_cmd_screen%"
echo Set WshShell = Nothing >> "%thisdir%\%vbs_file_to_start_without_cmd_screen%"


rem ----------- create shortcut in this directory ------------
@(  Echo Set WshShell = WScript.CreateObject("WScript.Shell"^)
    Echo Set oShellLink = WshShell.CreateShortcut("%thisdir%\Runelite.lnk"^)
    Echo oShellLink.TargetPath = """%thisdir%\%vbs_file_to_start_without_cmd_screen%"""
    Echo oShellLink.WindowStyle = 1
    Echo oShellLink.Hotkey = "CTRL+SHIFT+R"
    Echo oShellLink.IconLocation = "C:\Users\%USERNAME%\AppData\Local\RuneLite\RuneLite.exe, 0"
    Echo oShellLink.Description = "RuneLite"
    Echo oShellLink.WorkingDirectory = "%thisdir%"
    Echo oShellLink.Save) 1>"%thisdir%\CreateShortcut.vbs"
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




pause
exit

:nojava
echo - can not find %JAVAPATHH%
echo - INSTALL RUNELITE IN DEFAULT LOCATION PLEASE! 
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


