#include <stdio.h>
#include <string.h>

/*  tinyadventure.c - C-conversion of the "Tenliner Cave Adventure"
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
*/

/*  Compilation commands of Atari 800 XL-version:
    export CC65_HOME="/usr/local/share/cc65" # Set environment
    cl65 -Oi -t atari -Wl -D__RESERVED_MEMORY__=0x2000 -o tinyadventure.xex tinyadventure.c
*/

typedef unsigned char byte;
enum boolean {False, True};

const char texts[13][20] = {"Cannot do", "You walk", "Opened", "Closed", "a sword", "a key", "Nothing", "a chest", "a dragon", "a corpse", "taken", "you died", "you won"};

const char locations[4][5] = {"cave", "pit", "hall", "lake"};

char userinput[20];

enum items {None, key, sword};

byte my_input(char *arr, byte arrlen) {
    /* "arr" has to be a static array defined outside this function.
       It gets passed by reference to this function, so it's manipulated directly,
       and the results also take effect outside the function. */
    char c;
    int count;
    count = 0;
    c = getchar();
    while (c != '\n' && count < arrlen) {
        arr[count] = c;
        count++;
        c = getchar();
    }
    arr[count] = '\0';
    return count;
}

int main() {
    byte textnr;
    byte locationnr;
    byte chest_open;
    byte item;
    byte movement;
    textnr = 0;
    locationnr = 1;
    chest_open = False;
    item       = None;
    /*  CLS in Atari 800 XL-version:
        printf("%c", 125);
    */
    while (textnr < 11) {
        printf("You are in a %s ", locations[locationnr - 1]);
        my_input(userinput, 20);
        if (strcmp(userinput, "q") == 0) {
            puts("Bye.\n");
            break;
        }
        if (locationnr < 3 && strcmp(userinput, "north") == 0) {
            movement = 2;
        } else {
            movement = 0;
        }
        if (locationnr > 2 && strcmp(userinput, "south") == 0)
            movement -= 2;

        if (locationnr == 2 && strcmp(userinput, "west") == 0)
            movement += 1;

        if (locationnr == 3 && strcmp(userinput, "east") == 0)
            movement -= 1;

        if (locationnr == 2 && strcmp(userinput, "look chest") == 0) {
            textnr = 3;

            if (chest_open)
                textnr++;

            if (item == sword)
                textnr += 2;

        } else {
            textnr = 0;
        }
        if (locationnr == 3 && strcmp(userinput, "kill dragon") == 0) {
            textnr += 11;
            if (item == sword)
                textnr++;
        }
        if (movement != 0) {
            textnr++;
        }

        if (strcmp(userinput, "look") == 0)
            textnr += 5 + locationnr;

        if (strcmp(userinput, "inventory") == 0) {
            textnr += 6;
            if (item == key)
                textnr -= 1;
            if (item == sword)
                textnr -= 2;
        }

        if (locationnr == 4 && strcmp(userinput, "look corpse") == 0) {
            textnr += 6;
            if (item == None)
                textnr--;
        }
        if (locationnr == 4 && chest_open == False && item == None && strcmp(userinput, "get key") == 0)
            textnr += 10;

        if (locationnr == 2 && chest_open == False && item == key && strcmp(userinput, "open chest") == 0)
            textnr += 2;

        if (locationnr == 2 && chest_open == True && item == key && strcmp(userinput, "get sword") == 0)
            textnr += 10;

        locationnr += movement;

        if (strcmp(texts[textnr], "Opened") == 0)
            chest_open = True;

        if (strcmp(texts[textnr], "taken") == 0) {
            if (item == None) {
                item = key;
            }
            else if (item == key) {
                item = sword;
            }
        }
        /* printf("%d\n", item);
           printf("%d\n", chest_open); */
        printf("%s\n", texts[textnr]);
    }
    /*  For Atari 800 XL-version:
        printf("\nPress any key to start again. ");
        my_input(userinput, 20);
    */
    return 0;
}
