#include <stdio.h>
#include <string.h>

/*  move_example.c
    (C) 2021 hlubenow, GNU GPL 3 (or above)

    Quick example on how to manage locations and movement
    in an adventure game.
    Well, in C nothing is "quick", it seems.
*/

#define NUMBER_OF_DIRECTIONS 4

const char directions[NUMBER_OF_DIRECTIONS][2] = {"n", "e", "s", "w"};

const int locations[4][4] = {{2, 0, 0, 0},
                             {0, 3, 1, 0},
                             {4, 0, 0, 2},
                             {0, 0, 3, 0}};

const char rooms[4][5] = {"cave", "hall", "pit", "lake"};

int my_input(char *arr, int arrlen) {
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

int isInDirections(char *s) {
    int i;
    int index;
    index = -1;
    for (i = 0; i < NUMBER_OF_DIRECTIONS; i++) {
        if (strcmp(directions[i], s) == 0) {
            index = i;
            break;
        }
    }
    return index;
}

int main() {
    int roomnumber;
    int newroom;
    int i;
    int directionindex;
    char u[20];
    roomnumber = 1;

    while (1) {
        printf("You are in a %s: ", rooms[roomnumber - 1]);
        my_input(u, 20);
        if (strcmp(u, "q") == 0) {
            puts("Bye.");
            break;
        }
        directionindex = isInDirections(u);
        if (directionindex > -1) {
            newroom = locations[roomnumber - 1][directionindex];
            if (newroom == 0) {
                puts("Can't go there.");
            } else {
                roomnumber = newroom;
            }
        }
    }
}
