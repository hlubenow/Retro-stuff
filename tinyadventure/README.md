### tinyadventure.c

There's a text adventure game called "Tenliner Cave Adventure", that was written in just 10 lines of ZX81-Basic-code by Einar Saukas. It features text parser, 4 locations, 2 items, "inventory"-function and so on. It was an entry for a code competition, that was [described here](https://spectrumcomputing.co.uk/index.php?cat=96&id=30392). The project's README including the 10 lines of Sinclair Basic code can be found [here](https://spectrumcomputing.co.uk/zxdb/sinclair/entries/0030392/10CAVEADV.txt).
I heard about that game in [this Youtube video](https://www.youtube.com/watch?v=_d2g5BXdyfU).

To press that game into such few lines of code, it was necessary to write them in a rather cryptic way. After translating the code to Python and C, I finally realized, what the program was doing. I then expanded the code again into a more comprehendable version in C, which I upload here. Of course, this version is not that small any more.

Later, I retranslated the Python version back to ZX Spectrum BASIC. Use [bas2tap](https://github.com/speccyorg/bas2tap) to convert the text-file `tinyadventure.bas` to a file `tinyadventure.tap`, which then can be used in a ZX Spectrum emulator such as [fuse](http://fuse-emulator.sourceforge.net/).

License: GNU GPL 3 (or higher)
