@echo off
setlocal EnableDelayedExpansion

:: Counter for user IDs
set "id=0"

:home
cls
color 5
echo Welcome to the Chat Application
echo.

:menu
echo [1] Sign In
echo [2] Sign Up
echo [3] Exit (Type 'exit' to quit)
set /p choice=Enter your choice: 

if /i "%choice%"=="1" goto signin
if /i "%choice%"=="2" goto signup
if /i "%choice%"=="exit" (
    echo Exiting chat...
    goto :eof
)
goto menu

:signup
cls
color 5
echo Sign Up
echo.

:: Check if accounts.txt exists, if not, create it
if not exist accounts.txt (
    echo. > accounts.txt
)

:: Increment user ID
set /a "id+=1"

:: Prompt the user to enter a new username and password
set /p "new_username=Enter a new username: "
set /p "new_password=Enter a new password (more than 3 characters): "

:: Check if the username and password meet the requirements
if not defined new_username goto invalid_username
if not defined new_password goto invalid_password
if exist accounts.txt (
    findstr /c:"!new_username!:" accounts.txt >nul && (
        echo Username already exists!
        pause
        goto signup
    )
)

if "!new_username!"=="" goto invalid_username
if "!new_password!"=="" goto invalid_password
if "!new_password!"=="exit" goto :eof
if "!new_username!"=="exit" goto :eof
if "!new_password!"=="exit" goto :eof

if "!new_password:~3!"=="" goto invalid_password

:: Save the new account details
echo !id!:!new_username!:!new_password! >> accounts.txt
echo Account created successfully!
pause
goto home

:signin
cls
color 5
echo Sign In
echo.

:: Prompt the user to enter their username and password
set /p "username=Enter your username: "
set /p "password=Enter your password: "

:: Check if the username and password match
findstr /c:"!username!:!password!" accounts.txt >nul && (
    echo Sign in successful!
    set "current_user=!username!"
    pause
    goto chat
) || (
    echo Incorrect username or password!
    pause
    goto home
)

:invalid_username
echo Invalid username!
pause
goto signup

:invalid_password
echo Invalid password! Password must be more than 3 characters.
pause
goto signup

:chat
:: Clear the screen
cls
color 5

:chatloop
:: Prompt the user for input
set /p "message=Type your message: "

:: Check if the user wants to exit
if /i "%message%"=="exit" (
    echo Exiting chat...
    goto :eof
)

:: Get current date and time
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set "datetime=!datetime:~0,4!-!datetime:~4,2!-!datetime:~6,2! !datetime:~8,2!:!datetime:~10,2!:!datetime:~12,2!"

:: Save message to chatlog.txt
echo [%datetime%] !current_user!: %message% >> chatlog.txt

:: Display the message
echo [%datetime%] !current_user!: %message%

:: Go back to chat
goto chatloop
