@echo off
goto START
REM      _________ __                 __                               
REM     /   _____//  |_____________ _/  |______     ____  __ __  ______
REM     \_____  \\   __\_  __ \__  \\   __\__  \   / ___\|  |  \/  ___/
REM     /        \|  |  |  | \// __ \|  |  / __ \_/ /_/  >  |  /\___ \ 
REM    /_______  /|__|  |__|  (____  /__| (____  /\___  /|____//____  >
REM            \/                  \/          \//_____/            \/ 
REM ______________________                           ______________________
REM                       T H E   W A R   B E G I N S
REM	   Stratagus - A free fantasy real time strategy game engine
REM
REM	build.bat	-	The graphics and sound extractor.
REM
REM	(c) Copyright 1999-2003 by Lutz Sammer and Jimmy Salmon.
REM
REM	Stratagus is free software; you can redistribute it and/or modify
REM	it under the terms of the GNU General Public License as published
REM	by the Free Software Foundation; only version 2 of the License.
REM
REM	Stratagus is distributed in the hope that it will be useful,
REM	but WITHOUT ANY WARRANTY; without even the implied warranty of
REM	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
REM	GNU General Public License for more details.
REM	
REM	$Id: build.bat,v 1.47 2004/02/04 00:44:55 nehalmistry Exp $
REM
:START

REM
REM     Enter the letter of your CDROM drive.
REM

set CDROM=D:

REM
REM     Alternatively: Enter the path to WC2 on your hard drive.
REM	If you need to force expansion, use the -e option.
REM

REM SET CDROM="C:\War2"
REM SET EXPANSION=-e

REM
REM	This is the name of the directory where the files will be extracted.
REM     You shouldn't need to change this.
REM

set DIR=data.wc2




REM ###########################################################################
REM ##      DO NOT EDIT BELOW THIS LINE
REM ###########################################################################

set CONTRIB=contrib

if not [%1] == [] SET CDROM=%1
if not [%2] == [] SET DIR=%2
set ARCHIVE=%CDROM%\data

if not EXIST %ARCHIVE%\rezdat.war goto DIRERROR
if not EXIST %CONTRIB%\* goto CONTRIBERROR

if not EXIST %DIR% md %DIR%

REM ###########################################################################
REM ##      Extract
REM ###########################################################################

ECHO Extracting files...

REM ADD -e      To force the archive are expansion compatible
REM ADD -n      To force the archive is not expansion compatible   
wartool %EXPANSION% %ARCHIVE% %DIR%

REM copy own supplied files

copy /b %CONTRIB%\cross.png %DIR%\graphics\ui\cursors >nul
copy /b %CONTRIB%\red_cross.png %DIR%\graphics\missiles >nul
copy /b %CONTRIB%\mana.png %DIR%\graphics\ui >nul
copy /b %CONTRIB%\mana2.png %DIR%\graphics\ui >nul
copy /b %CONTRIB%\health.png %DIR%\graphics\ui >nul
copy /b %CONTRIB%\health2.png %DIR%\graphics\ui >nul
copy /b %CONTRIB%\food.png %DIR%\graphics\ui >nul
copy /b %CONTRIB%\score.png %DIR%\graphics\ui >nul
copy /b "%CONTRIB%\ore,stone,coal.png" %DIR%\graphics\ui >nul
copy /b %CONTRIB%\stratagus.png %DIR%\graphics\ui >nul
md %DIR%\music
copy /b %CONTRIB%\toccata.mod.gz %DIR%\music\default.mod.gz >nul

REM ###########################################################################
REM ##      MISC
REM ###########################################################################

REM Compress HOW-TODO ?

REM	*** Copy original maps into data directory ***
REM	for the expansion cd,
if not exist %ARCHIVE%\..\puds\multi\* goto NOEXP
md %DIR%\maps\single
md %DIR%\maps\strange
copy /b %ARCHIVE%\..\puds\multi\*.pud %DIR%\maps\multi >nul
copy /b %ARCHIVE%\..\puds\single\*.pud %DIR%\maps\single >nul
copy /b %ARCHIVE%\..\puds\strange\*.pud %DIR%\maps\strange >nul
:NOEXP
REM	for the original cd,
if exist %ARCHIVE%\*.pud copy /b %ARCHIVE%\*.pud %DIR%\maps >nul

REM	*** Copy contrib maps into data directory ***
md %DIR%\maps\other
copy /b maps\multi\* %DIR%\maps\other >nul
REM copy /b maps\single\* %DIR%\maps\other >nul

REM	*** Setup the default pud ***
copy /b %DIR%\maps\multi\(2)mysterious-dragon-isle.pud.gz %DIR%\maps\default.pud.gz >nul

REM	*** Copy script files ***
md %DIR%\scripts\ai
md %DIR%\scripts\human
md %DIR%\scripts\orc
md %DIR%\scripts\tilesets
copy scripts\*.lua %DIR%\scripts >nul
copy scripts\ai\*.lua %DIR%\scripts\ai >nul
copy scripts\human\*.lua %DIR%\scripts\human >nul
copy scripts\orc\*.lua %DIR%\scripts\orc >nul
copy scripts\tilesets\*.lua %DIR%\scripts\tilesets >nul

echo WC2 data setup is now complete
echo NOTE: you do not need to run this script again
goto EOF

:DIRERROR
echo ERROR: '%ARCHIVE%\rezdat.war' not found
echo Specify the location of the data files with the '-p' option
goto EOF

:CONTRIBERROR
echo ERROR: '%CONTRIB%' not found; try running %0
echo 	from the toplevel stratagus directory
goto EOF

:EOF
pause
