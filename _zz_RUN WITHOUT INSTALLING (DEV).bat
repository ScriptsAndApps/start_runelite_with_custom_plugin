@echo off

rem ------- custom variables ------

SET outfilename=_temp_runs_classes_with_runelite.bat
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
%outfilename% & del %outfilename% 


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


