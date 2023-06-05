@echo off
SetLocal EnableDelayedExpansion
echo *********************************************
echo *      Utility to remove oracke java.       *
echo *         tanmoydutta.roy@hcl.com           *
echo *********************************************

set OPEN_JAVA_HOME=D:\Delete\Mattel\OpenJDK8

echo Detecting ORACLE JAVA...

REM Find Oracle Java & Verions
java -XshowSettings:properties -version 2>&1 | findstr /C:"java.vendor = Oracle Corporation" /C:"java.version ="

REM set properties=`java -XshowSettings:properties -version 2>&1`
REM echo %properties% | findstr /C:"java.vendor = Oracle Corporation" /C:"java.version ="

REM If Oracle Java found then continue
if errorlevel 1 (echo No Oracle JAVA found && set ORACLE_JDK_PRESENT=NO) else (echo Found Oracle JAVA && set ORACLE_JDK_PRESENT=YES)

REM Extract Oracle Java version
"c:\Program Files\Java\jdk1.8.0_231\bin\java.exe" -XshowSettings:properties -version 2>&1 | findstr /C:"java.version =" >> java.version.txt
set /p oracle.java.version=<java.version.txt	
del java.version.txt
set oracle.java.version=%oracle.java.version:~19,5%

REM If Other vendor Java detected then exit.
if ORACLE_JDK_PRESENT==NO (
	echo Exiting..
	exit /B 0
) else (
	echo Oracle JDK present = %ORACLE_JDK_PRESENT%
	echo Version = %oracle.java.version%
)

REM Check older version java
echo %oracle.java.version% | findstr /m "1.7" 
if %errorlevel%==0  (
	echo Older Java version detected. No action required.
	REM exit /B 0
)

REM Starting uninstall
echo %errorlevel%
echo Initiating uninstallation of Oracle JAVA %oracle.java.version%
REM wmic product where "name like 'Java%%'" call uninstall /nointeractive

REM check uninstall error code
if errorlevel 0 (
	echo Uninstall done.
	
)else ( 
	echo Error while removing Oracle Java.
	exit /B 0
	)

REM Download OpenJdk
curl -o "openjdk-1.8.0.372.msi" https://access.cdn.redhat.com/content/origin/files/sha256/23/23da371bead63e0909f6206f48c363a0ffc088b5fd2dbb5fce39668bdfeb528e/java-1.8.0-openjdk-1.8.0.372-1.b07.redhat.windows.x86_64.msi?_auth_=1684835246_68e2b48a89472048f317737a53b6d791

REM Install OpenJDK on background
MsiExec.exe /i openjdk-1.8.0.372.msi INSTALLDIR=%OPEN_JAVA_HOME% /qn /L*v "%WINDIR%\Temp\openjdk8-install.log"

echo Install logs place under "%WINDIR%\Temp\openjdk8-install.log"

REM check uninstall error code
if errorlevel 0 (
	echo Open JDK install completed.
) else ( echo Error while installing OpenJDK, contact admin.)

REM set PATH variable
set PATH=%PATH%;%OPEN_JAVA_HOME%\bin

echo Task completed..
