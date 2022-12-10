@echo off
setlocal enabledelayedexpansion
set points=0
set points2=0
for /f "tokens=1,2,3 delims=: " %%i in ('findstr /N "^" "%~n0.txt"') do (
	rem echo %%i %%j %%k
	set moves[%%i][0]=%%j
	set moves[%%i][0]=!moves[%%i][0]:A=1!
	set moves[%%i][0]=!moves[%%i][0]:B=2!
	set moves[%%i][0]=!moves[%%i][0]:C=3!
	set moves[%%i][1]=%%k
	set moves[%%i][1]=!moves[%%i][1]:X=1!
	set moves[%%i][1]=!moves[%%i][1]:Y=2!
	set moves[%%i][1]=!moves[%%i][1]:Z=3!
	rem echo !moves[%%i][0]! !moves[%%i][1]!
	set length=%%i
)
for /l %%i in (1,1,%length%) do (
	set matchpoints=!moves[%%i][1]!
	if !moves[%%i][0]! equ !moves[%%i][1]! set /A matchpoints+=3
	set /A "tempmove=(!moves[%%i][0]!+1)%%3"
	set /A "tempmove2=(!moves[%%i][1]!)%%3"
	if !tempmove! equ !tempmove2! set /A matchpoints+=6
	set /A points+=!matchpoints!
	set /A "matchpoints=(!moves[%%i][1]!-1)*3"
	if !moves[%%i][1]! equ 2 set /A matchpoints+=!moves[%%i][0]!
	set /A "tempmove=(!moves[%%i][0]!+1)%%3+1"
	if !moves[%%i][1]! equ 1 set /A matchpoints+=!tempmove!
	set /A "tempmove=(!moves[%%i][0]!%%3)+1"
	if !moves[%%i][1]! equ 3 set /A matchpoints+=!tempmove!
	set /A points2+=!matchpoints!
)
echo %points%
echo %points2%