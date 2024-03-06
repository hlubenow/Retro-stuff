1 REM tinyadventure.bas
2 REM Copyright (C) 2021 hlubenow
3 REM This program is free software: you can redistribute it and/or modify
4 REM it under the terms of the GNU General Public License as published by
5 REM the Free Software Foundation, either version 3 of the License, or
6 REM (at your option) any later version.
7 REM This program is distributed in the hope that it will be useful,
8 REM but WITHOUT ANY WARRANTY; without even the implied warranty of
9 REM MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10 REM GNU General Public License for more details.
11 REM You should have received a copy of the GNU General Public License
12 REM along with this program. If not, see <https://www.gnu.org/licenses/>.
20 LET locationnr = 1
30 LET chestopen = 0
40 LET i$ = ""
50 DIM t$(13, 10)
60 FOR i = 1 TO 13: READ t$(i): NEXT i
70 DIM l$(4, 4)
80 FOR i = 1 TO 4: READ l$(i): NEXT i
100 REM
110 REM Main loop
120 LET movement = 0
130 LET textnr = 0
140 LET a$ = l$(locationnr): GO SUB 5000: REM rstrip a$
150 IF a$ = "lake" THEN PRINT "You are by a lake.": GO TO 170
160 PRINT "You are in a " + a$ + "."
170 INPUT "What now? "; u$
180 IF u$ = "q" THEN PRINT: PRINT "Bye.": STOP
190 IF locationnr < 3 AND u$ = "north" THEN LET movement = 2
200 IF locationnr > 2 AND u$ = "south" THEN LET movement = movement - 2
210 IF locationnr = 2 AND u$ = "west" THEN LET movement = movement + 1
220 IF locationnr = 3 AND u$ = "east" THEN LET movement = movement - 1
230 IF locationnr = 2 AND u$ = "look chest" THEN GO SUB 2000
240 IF locationnr = 3 AND u$ = "kill dragon" THEN GO SUB 3000
250 IF movement <> 0 THEN LET textnr = textnr + 1
260 IF u$ = "look" THEN LET textnr = textnr + 5 + locationnr
270 IF u$ = "inventory" THEN GO SUB 1000
280 IF locationnr = 4 AND u$ = "look corpse" THEN LET textnr = textnr + 6: IF i$ = "" THEN LET textnr = textnr - 1
290 IF locationnr = 4 AND chestopen = 0 AND i$ = "" AND u$ = "take key" THEN LET textnr = textnr + 10
300 IF locationnr = 2 AND chestopen = 0 AND i$ = "key" AND u$ = "open chest" THEN LET textnr = textnr + 2
310 IF locationnr = 2 AND chestopen = 1 AND i$ = "key" AND u$ = "take sword" THEN LET textnr = textnr + 10
320 LET locationnr = locationnr + movement
330 LET b$ = t$(textnr + 1): GO SUB 5050: REM rstrip b$
340 IF b$ = "Opened" THEN LET chestopen = 1
350 IF b$ = "Taken" THEN GO SUB 4000
360 PRINT b$ + "."
370 PRINT
380 IF textnr < 11 THEN GO TO 100
390 GO TO 9999: REM End of program.
1000 REM
1010 REM Inventory
1020 LET textnr = textnr + 6
1030 IF i$ = "key" THEN LET textnr = textnr - 1: RETURN
1040 IF i$ = "sword" THEN LET textnr = textnr - 2
1050 RETURN
2000 REM
2010 REM look into chest
2020 LET textnr = 3
2030 IF chestopen = 1 THEN LET textnr = textnr + 1
2040 IF i$ = "sword" THEN LET textnr = textnr + 2
2050 RETURN
3000 REM
3010 REM Kill dragon
3020 LET textnr = textnr + 11
3030 IF i$ = "sword" THEN LET textnr = textnr + 1
3040 RETURN
4000 REM
4010 REM Take something
4020 IF i$ = "" THEN LET i$ = "key": RETURN
4030 IF i$ = "key" THEN LET i$ = "sword"
4040 RETURN
5000 REM
5010 REM rstrip a$
5020 IF a$ = "pit " THEN LET a$ = "pit"
5030 RETURN
5050 REM
5060 REM rstrip b$
5070 FOR i = 10 TO 2 STEP -1
5080 IF b$(i) <> " " THEN RETURN
5090 LET b$ = b$(1 TO i - 1)
5100 NEXT i
5110 RETURN
9000 REM
9010 REM Data
9020 DATA "Cannot do", "You walk", "Opened", "Closed"
9030 DATA "A sword", "A key", "Nothing", "a chest"
9040 DATA "A dragon", "A corpse"
9050 DATA "Taken", "You died", "You won"
9060 DATA "cave", "pit", "hall", "lake"
