#!/usr/bin/python
# coding: utf-8

""" move_example.py
    (C) 2021 hlubenow, GNU GPL 3 (or above)

    Quick example on how to manage locations and movement
    in an adventure game.
"""

directions = ("n", "e", "s", "w")

locations = ((2, 0, 0, 0),
             (0, 3, 1, 0),
             (4, 0, 0, 2),
             (0, 0, 3, 0))

rooms = ("cave", "hall", "pit", "lake")

roomnumber = 1

while True:
    u = raw_input("You are in a " + rooms[roomnumber - 1] + ": ")
    if u == "q":
        print "Bye."
        break
    if u in directions:
        newroom = locations[roomnumber-1][directions.index(u)]
        if newroom == 0:
            print "Can't go there."
        else:
            roomnumber = newroom
