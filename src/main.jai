#import "Basic";
#import "stb_image_write";

nanosvg :: #library,no_dll "../.build/libnanosvg";

nsvgParseFromFile :: (filename: *u8, units: *u8, dpi: float) -> *void #foreign nanosvg;
nsvgCreateRasterizer :: () -> *void #foreign nanosvg;
nsvgRasterize :: (r: *void, image: *void, tx: float, ty: float, scale: float, dst: *u8, width: int, height: int, stride: int) #foreign nanosvg;

main :: () {
    width :: 120;
    height :: 120;
    file_name :: "assets/cog.svg";
    output_file_name :: "cog.png";
    units :: "px";
    dpi : float : 96;

    image := nsvgParseFromFile(file_name.data, "px".data, dpi);
    if (image == null) {
        print("Could not load image.\n");
        exit(1);
    }
    print("Image loaded: %\n", file_name);

    rasterizer := nsvgCreateRasterizer();
    pixels := alloc(width*height*4);
    nsvgRasterize(rasterizer, image, 0, 0, 1, pixels, width, height, width*4);

    result := stbi_write_png(output_file_name, width, height, 4, pixels, width*4);

    if (result != 0) print("Image written: %\n", output_file_name);
    else print("stbi_write_png result: %\n", result);

    // TODO: clean up
}
