rem ------- custom variables ------

SET outfilename=__this_runs_the_java_with_plugin.bat
SET vbs_file_to_start_without_cmd_screen=__this_runs_the_bat_silent.vbs
SET reposetory=C:\Users\%USERNAME%\.runelite\repository2
SET JAVAPATHH="%JAVA_HOME%\bin\javaw.exe"
rem SET JAVAPATHH="C:\Program Files\Java\jdk-14\bin\javaw.exe"


rem ------- variables you do not edit ------
SET disir=%CD%
SET outfile=%disir%\%outfilename%



rem ----------- clear all files before creating them ----------- 
del \f "%disir%\%outfilename%"
del \f "%disir%\%vbs_file_to_start_without_cmd_screen%"
del \f "%disdir%\Runelite.lnk"



rem ----------- get the test class name ------------
SET CLASSTORUN=com.


	cd "%disir%\build\classes\java\test\com\*.*"
		for /d %%d in (*.*) do (
			call SET bb=%%d;
			call SET CLASSTORUN=%%CLASSTORUN%%%%~nxd.
		)
	cd "%disir%"

	cd "%bb%"
		for /R %%F IN (*.class) DO (
		 set filename=%%~nxF
		)
	cd "%disir%"
	
SET CLASSTORUN=%CLASSTORUN%%filename:~0,-6%



rem ----------- create string for batchfile ------------
SET outstring=%JAVAPATHH% -Dfile.encoding=windows-1252 -Duser.country=US -Duser.language=en -Duser.variant -ea -cp "


	cd "%disir%\build\classes\java\*.*"
		for /d %%d in (*.*) do (
			rem call  SET outstring=%%outstring%%%reposetory%\%%~nxf;
			call SET outstring=%%outstring%%%disir%\build\classes\java\%%d\;
		)
	cd "%disir%"


 
	cd "%reposetory%"
		for /R %%f in (*.jar) do (
			call  SET outstring=%%outstring%%%reposetory%\%%~nxf;
		)
	cd "%disir%"
call SET outstring=%%outstring%%" %CLASSTORUN% 
rem ----------- write strings to batchfile ------------

echo %outstring% >> "%outfile%"





rem ----------- create silent batch runner ------------
echo Set WshShell = CreateObject("WScript.Shell") >> "%disir%\%vbs_file_to_start_without_cmd_screen%"
echo WshShell.Run chr(34) ^& "%outfilename%" ^& Chr(34), 0  >> "%disir%\%vbs_file_to_start_without_cmd_screen%"
echo Set WshShell = Nothing >> "%disir%\%vbs_file_to_start_without_cmd_screen%"





rem ----------- create shortcut in this directory ------------
@(  Echo Set WshShell = WScript.CreateObject("WScript.Shell"^)
    Echo Set oShellLink = WshShell.CreateShortcut("%disir%\Runelite.lnk"^)
    Echo oShellLink.TargetPath = """%disir%\%vbs_file_to_start_without_cmd_screen%"""
    Echo oShellLink.WindowStyle = 1
    Echo oShellLink.Hotkey = "CTRL+SHIFT+R"
    Echo oShellLink.IconLocation = "C:\Users\%USERNAME%\AppData\Local\RuneLite\RuneLite.exe, 0"
    Echo oShellLink.Description = "RuneLite"
    Echo oShellLink.WorkingDirectory = "%disir%"
    Echo oShellLink.Save) 1>"%disir%\CreateShortcut.vbs"
rem      @%SystemRoot%\System32\cscript.exe //NoLogo "%disir%\CreateShortcut.vbs" && Del "%disir%\CreateShortcut.vbs"

rem ----------- create shortcut desktop------------
@(  Echo Set WshShell = WScript.CreateObject("WScript.Shell"^)
    Echo Set oShellLink = WshShell.CreateShortcut("%userprofile%/desktop/Runelite_EDIT_THIS_NAME.lnk"^)
    Echo oShellLink.TargetPath = """%disir%\%vbs_file_to_start_without_cmd_screen%"""
    Echo oShellLink.WindowStyle = 1
    Echo oShellLink.Hotkey = "CTRL+SHIFT+R"
    Echo oShellLink.IconLocation = "C:\Users\%USERNAME%\AppData\Local\RuneLite\RuneLite.exe, 0"
    Echo oShellLink.Description = "RuneLite"
    Echo oShellLink.WorkingDirectory = "%disir%"
    Echo oShellLink.Save) 1>"%disir%\CreateShortcut.vbs"
rem      @%SystemRoot%\System32\cscript.exe //NoLogo "%disir%\CreateShortcut.vbs" && Del "%disir%\CreateShortcut.vbs"

pause
