rem ------- custom variables ------

SET outfilename=_temp_runs_classes_with_runelite.bat
SET reposetory=C:\Users\%USERNAME%\.runelite\repository2
SET JAVAPATHH="%JAVA_HOME%\bin\javaw.exe"
rem SET JAVAPATHH="C:\Program Files\Java\jdk-14\bin\javaw.exe"


rem ------- variables you do not edit ------
SET disir=%CD%
SET outfile=%disir%\%outfilename%



rem ----------- clear all files before creating them ----------- 
del \f "%disir%\%outfilename%"


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
echo created %outfilename% 
%outfilename% & del %outfilename% 