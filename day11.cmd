@echo off
setlocal enabledelayedexpansion
set "output="
set monkeynum=0
for /f "delims=" %%i in ('findstr /N "^" "%~n0.txt"') do (
	set line=%%i
	set line=!line:*:=!
	if defined line (
		set line=!line:  =!
		set line=!line::=!
		set line=!line:, =,!
		call :readline
	)
)
for /l %%i in (1,1,20) do (
	for /l %%x in (0,1,%monkeynum%) do (
		for %%G in (!monkey[%%x][items]!) do (
			set /A monkey[%%x][count]+=1
			set num=%%G
			set /A !monkey[%%x][op]:G=%%G!
			set /A num/=3
			set /A test=!num!%%!monkey[%%x][test]!
			if !test!==0 (
				if defined monkey[!monkey[%%x][true]!][items] (
					call set monkey[!monkey[%%x][true]!][items]=%%monkey[!monkey[%%x][true]!][items]%%,!num!
				) else (
					set monkey[!monkey[%%x][true]!][items]=!num!
				)
			) else (
				if defined monkey[!monkey[%%x][false]!][items] (
					call set monkey[!monkey[%%x][false]!][items]=%%monkey[!monkey[%%x][false]!][items]%%,!num!
				) else (
					set monkey[!monkey[%%x][false]!][items]=!num!
				)
			)
		)
		set "monkey[%%x][items]="
	)
)
set first=-1
set second=-1
set monkey[-1][count]=0
for /l %%x in (0,1,%monkeynum%) do (
	if %%x neq !first! (
		if %%x neq !second! (
			call set tmp=%%monkey[!first!][count]%%
			call set tmp2=%%monkey[!second!][count]%%
			if !monkey[%%x][count]! gtr !tmp! (
				set second=!first!
				set first=%%x
			) else if !monkey[%%x][count]! gtr !tmp2! (
				set second=%%x
			)
		)
	)
)
set /A output=!monkey[%first%][count]!*!monkey[%second%][count]!
echo %output%
endlocal
exit /b
:readline
for /f "tokens=1,2" %%x in ("!line!") do (
	set command=%%x
	set qual=%%y
)
if %command%==Monkey (
	set monkeynum=%qual%
	set monkey[%qual%][count]=0
) else if %command%==Starting (
	set monkey[%monkeynum%][items]=!line:Starting items =!
) else if %command%==Operation (
	set monkey[%monkeynum%][op]=!line:Operation =!
	set monkey[%monkeynum%][op]=!monkey[%monkeynum%][op]: =!
	set monkey[%monkeynum%][op]=!monkey[%monkeynum%][op]:new=num!
	set monkey[%monkeynum%][op]=!monkey[%monkeynum%][op]:old=G!
) else if %command%==Test (
	set monkey[%monkeynum%][test]=!line:Test divisible by =!
) else if %command%==If (
	set monkey[%monkeynum%][%qual%]=!line:If %qual% throw to monkey =!
)
exit /b