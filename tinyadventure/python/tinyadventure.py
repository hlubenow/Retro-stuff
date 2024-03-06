#!/usr/bin/python
# coding: utf-8

"""
    tinyadventure.py - Python-conversion of the "Tenliner Cave Adventure"
                       by Einar Saukas.


    Copyright (C) 2021 hlubenow

    This program is free software: you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""

locationnr = 1
chest_open = False
item       = None

texts = ("Cannot do", "You walk", "Opened", "Closed", "a sword", "a key",
         "Nothing", "a chest", "a dragon", "a corpse", "taken", "you died", "you won")

locations = ("cave", "pit", "hall", "lake")

textnr = 0
while textnr < 11:
    userinput = raw_input("You are in a " + locations[locationnr - 1] + " ")
    if userinput == "q":
        print "Bye."
        print
        break
    if locationnr < 3 and userinput == "north":
        movement = 2
    else:
        movement = 0
    if locationnr > 2 and userinput == "south":
        movement -= 2
    if locationnr == 2 and userinput == "west":
        movement += 1
    if locationnr == 3 and userinput == "east":
        movement -= 1
    if locationnr == 2 and userinput == "look chest":
        textnr = 3
        if chest_open:
            textnr += 1
        if item == "sword":
            textnr += 2
    else:
        textnr = 0
    if locationnr == 3 and userinput == "kill dragon":
        textnr += 11
        if item == "sword":
            textnr += 1
    if movement != 0:
        textnr += 1

    if userinput == "look":
        textnr += 5 + locationnr

    if userinput == "inventory":
        textnr += 6
        if item == "key":
            textnr -= 1
        if item == "sword":
            textnr -= 2

    if locationnr == 4 and userinput == "look corpse":
        textnr += 6
        if item == None:
            textnr -= 1

    if locationnr == 4 and not chest_open and not item and userinput == "get key":
        textnr += 10
    if locationnr == 2 and not chest_open and item == "key" and userinput == "open chest":
        textnr += 2
    if locationnr == 2 and chest_open and item == "key" and userinput == "get sword":
        textnr += 10
    locationnr += movement

    if texts[textnr] == "Opened":
        chest_open = True

    if texts[textnr] == "taken":
        if item == None:
            item = "key"
        elif item == "key":
            item = "sword"

    # print item
    # print chest_open
    print texts[textnr]
