#!/bin/bash

# "create_d64": Use the "petcat" and "c1541"-commands of the "Vice" emulator,
# to create a ".d64" C64 disk file from a text-file with C64 BASIC code in the
# special format required by the mentioned commands.

# (C) H. Lubenow, 2024
# License: GNU GPL 3.

# Set the name of the files, you want to process.
# For example, if you want to process a file called "out.txt",
# set the variable "name" to "out" here:

name="out"

txtfile="$name.txt"
basfile="$name.bas"
diskfile="$name.d64"
prgname="$name.prg"

petcat -w2 -o "$basfile" -- "$txtfile"
c1541 -format diskname,id d64 "$diskfile" -attach "$diskfile" -write "$basfile" "$prgname"

# Automatically start the emulator. Delete the "#" at the beginning of the line, to activate:
# x64sc -default -VICIIfull -joydev1 "4" -joydev2 "4" "$diskfile"
