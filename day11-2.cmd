@echo off
setlocal enabledelayedexpansion
set "output="
set monkeynum=0
for /f "delims=" %%i in ('findstr /N "^" "day11.txt"') do (
	set line=%%i
	set line=!line:*:=!
	if defined line (
		set line=!line:  =!
		set line=!line::=!
		set line=!line:, =,!
		call :readline
	)
)
for /l %%i in (1,1,10000) do (
	for /l %%x in (0,1,%monkeynum%) do (
		for %%G in (!monkey[%%x][items]!) do (
			set /A monkey[%%x][count]+=1
			set num=%%G
			if not "!monkey[%%x][op]:G*G=!"=="!monkey[%%x][op]!" (
				for /f %%a in ('powershell -command "(!num!*!num!)%%%LCM%"') do (
					set num=%%a
				)
			) else (
				set /A !monkey[%%x][op]:G=%%G!
				set /A num=!num!%%%LCM%
			)
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
	echo !monkey[%%x][count]!
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
powershell -command "!monkey[%first%][count]!*!monkey[%second%][count]!"
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
	if not defined LCM (
		set LCM=!monkey[%monkeynum%][test]!
	) else (
		call :GCD GCD !LCM! !monkey[%monkeynum%][test]!
		set /A "LCM=(!LCM!*!monkey[%monkeynum%][test]!)/!GCD!"
	)
) else if %command%==If (
	set monkey[%monkeynum%][%qual%]=!line:If %qual% throw to monkey =!
)
exit /b
:GCD <return> <first> <second>
setlocal
set a=%2
set b=%3
:GCDLoop
if %b% neq 0 (
	set a=%b%
	set /A b=%a%%%%b%
	goto GCDLoop
)
endlocal & set %1=%a%
exit /b