@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

SET folder_active=%AppData%\Guild Wars 2
SET filepath_active=%AppData%\Guild Wars 2\Local.dat
SET filepath_settings=%AppData%\Guild Wars 2\GFXSettings.Gw2-64.exe.xml

SET folder_accounts=%AppData%\Guild Wars 2\ACCOUNTS
MKDIR "%folder_accounts%"

::Load GW2 settings
SET /P gw2settings=<"%filepath_settings%"

::Find install path
FOR /F "tokens=*" %%i IN ('FINDSTR /C:"INSTALLPATH" "%filepath_settings%"') DO (
SET folder_install="%%i"
)

SET folder_install=%folder_install:\"/>=%
SET folder_install=%folder_install:"<=%
SET folder_install=%folder_install:*"=%
SET folder_install=%folder_install:"=%

SET filepath_executable=%folder_install%\Gw2-64.exe

:START
::Get saved accounts
CLS
ECHO.

SET /A count_accounts=0
SET account_numbers=
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
)
ECHO Accounts[%count_accounts%]:

SET /A count_accounts=0
SET account_numbers=
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
ECHO %%~ni
)

IF !count_accounts! EQU 0 (
ECHO No Accounts found. Save your accounts first.
)

IF !count_accounts! GEQ 9 (
ECHO Maximum number of accounts reached.
)

ECHO.
ECHO Select Action:
ECHO.
ECHO 1: SELECT account - SELECTS a saved account 
ECHO.
ECHO 2: SAVE account - SAVES your current account
ECHO Make sure the "Remember Account Name" and/or "Remember Password" options are checked in the GW2 Launcher
ECHO and you have logged in at least once.
ECHO Can save up to 9 accounts.
ECHO.
ECHO 3: DELETE account - DELETES a saved account
ECHO.
CHOICE /C:123

IF !count_accounts! GEQ 9 (
IF %ERRORLEVEL% == 2 (
GOTO START
)
)

GOTO ACTION_%ERRORLEVEL%

PAUSE

:SELECT_ACCOUNT
:ACTION_1
::Get saved accounts
CLS
SET /A count_accounts=0
ECHO.
ECHO Accounts:
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
ECHO !count_accounts!: %%~ni
SET account_numbers=!account_numbers!!count_accounts!
)

ECHO.
CHOICE /C %account_numbers% /M "Select Account:"

SET /A count_accounts=0
SET account_numbers=
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
SET account_selected=%%~i
SET account_name=%%~ni
IF !count_accounts!==%ERRORLEVEL% GOTO END_SELECT1
)
:END_SELECT1
COPY /Y "%account_selected%" "%filepath_active%" > NUL
ECHO.
ECHO %account_name% selected.
PING 127.0.0.1 -n 2 > NUL

GOTO GW2_LAUNCH

PAUSE

:SAVE_ACCOUNT
:ACTION_2
::Get saved accounts
CLS
SET /A count_accounts=0
ECHO.
ECHO Accounts:
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
ECHO !count_accounts!: %%~ni
SET account_numbers=!account_numbers!!count_accounts!
)

ECHO.
ECHO [7mMake sure the "Remember Account Name" and/or "Remember Password" options are checked in the GW2 Launcher 
ECHO and you have logged in at least once.
ECHO You'll have to re-save your account after changing your password.
ECHO Can save up to 9 accounts.[0m
ECHO.
SET /P account_name=Name your saved account:
SET account_selected=%folder_accounts%\%account_name%.dat

ECHO.
TASKKILL /f /IM Gw2-64.exe > NUL
PING 127.0.0.1 -n 2 > NUL
COPY /Y "%filepath_active%" "%account_selected%" > NUL
ECHO "%account_name%" SAVED
PING 127.0.0.1 -n 2 > NUL
GOTO START

:DELETE_ACCOUNT
:ACTION_3
::Get saved accounts
CLS
SET /A count_accounts=0
SET account_numbers=
ECHO.
ECHO Accounts:
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
ECHO !count_accounts!: %%~ni
SET account_numbers=!account_numbers!!count_accounts!
)

ECHO.
CHOICE /C %account_numbers% /M "DELETE Account:"

SET /A count_accounts=0
SET account_numbers=
FOR %%i IN ("%folder_accounts%\*.dat") DO (
SET /A count_accounts=count_accounts+1
SET account_selected=%%~i
SET account_name=%%~ni
IF !count_accounts!==%ERRORLEVEL% GOTO END_SELECT3
)
:END_SELECT3
ECHO.
ECHO DELETING "%account_name%"
CHOICE /C:YN /M "Are you sure you want to delete this account? [Y]es / [N]o?"
IF %ERRORLEVEL%==2 GOTO START

DEL /F /Q "%account_selected%" > NUL
PING 127.0.0.1 -n 2 > NUL
GOTO START

:GW2_LAUNCH
START "" "%filepath_executable%" -mapLoadInfo
PING 127.0.0.1 -n 5 > NUL

:EOF
EXIT