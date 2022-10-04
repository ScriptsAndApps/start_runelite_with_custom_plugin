@echo off

SET finaljarname=RuneLite.jar
SET runelitedir=C:\Users\%USERNAME%\.runelite

SET thisdir=%CD%

del "%thisdir%\CreateShortcut.vbs"

rem ----------- create shortcut script in this directory ------------
echo  Creating script to make shortcuts to the new jar
@(  echo SET WshShell = WScript.CreateObject("WScript.Shell"^)
    echo SET oShellLink = WshShell.CreateShortcut("%thisdir%\RuneLite.lnk"^)
    echo oShellLink.TargetPath = """C:\Users\%USERNAME%\AppData\Local\RuneLite\RuneLite.exe"""
    echo oShellLink.WindowStyle = 1
    echo oShellLink.IconLocation = "C:\Users\%USERNAME%\AppData\Local\RuneLite\RuneLite.exe, 0"
    echo oShellLink.Description = "RuneLite"
    echo oShellLink.WorkingDirectory = "C:\Users\%USERNAME%\AppData\Local\RuneLite"
	echo oShellLink.Save) 1>"%thisdir%\CreateShortcut.vbs"

SET startmenu=C:\Users\%USERNAME%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
SET desktopp=C:\Users\%USERNAME%\Desktop

del %desktopp%\RuneLite.lnk 
del %thisdir%\RuneLite.lnk 
@%SystemRoot%\System32\cscript.exe //NoLogo "%thisdir%\CreateShortcut.vbs"
move RuneLite.lnk "C:\Users\%USERNAME%\Desktop"

del %startmenu%\RuneLite.lnk 
del %thisdir%\RuneLite.lnk 
@%SystemRoot%\System32\cscript.exe //NoLogo "%thisdir%\CreateShortcut.vbs"
move RuneLite.lnk "%startmenu%"


rem this file should not exist
del "%startmenu%\RuneLite\RuneLite.lnk.back"

rmdir "%startmenu%\RuneLite\"


del "%thisdir%\CreateShortcut.vbs"

del %runelitedir%\%finaljarname%

echo -
echo    Runelite should work normal now. Otherwise re-run runelite setup from official site
echo -
pause