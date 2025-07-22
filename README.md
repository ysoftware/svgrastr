# Simple SVG rasterizer

This project is an example of using foreign code in Jai.
Compatible with compiler version beta 0.2.016.

The final executable is statically linked with a single-header C library, that is being initially created by a C compiler:
```bash
cc:
nanosvg.h & nanosvgrast.h > nanosvg.c > nanosvg.o

ar:
nanosvg.o > libnanosvg.a

jai:
main.jai & libnanosvg.a > svgrastr
```

### Build and run:
```bash
jai first.jai

./svgrastr -help
----- Here is the list of valid arguments: -----
    -i: SVG input file path
    -o: PNG output file path
    -w: Output file width
    -h: Output file height

    -help, -HELP, -?: Show the list of commands.

./svgrastr -i assets/cog.svg -o cog.png -w 120 -h 120
File written: cog.png
```

### Tools
- jai
- cc
- ar

### Dependencies:
- [nanosvg](https://github.com/memononen/nanosvg)
- [stb_image](https://github.com/nothings/stb)
