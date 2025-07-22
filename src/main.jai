#import "Basic";
#import "Command_Line";
#import "stb_image_write";

lm :: #library,system,link_always "m";
nanosvg :: #library,no_dll "../.build/libnanosvg";

NSVGimage :: struct {
    width: float;
    height: float;
    shapes: *void;
}

NSVGrasterizer :: *void;

nsvgParseFromFile :: (filename: *u8, units: *u8, dpi: float) -> *NSVGimage #foreign nanosvg;
nsvgCreateRasterizer :: () -> NSVGrasterizer #foreign nanosvg;
nsvgRasterize :: (r: *NSVGrasterizer, image: *void, tx: float, ty: float, scale: float, dst: *u8, width: int, height: int, stride: int) #foreign nanosvg;
nsvgDelete :: (image: *NSVGimage) #foreign nanosvg;
nsvgDeleteRasterizer :: (r: *NSVGrasterizer) #foreign nanosvg;

Arguments :: struct {
    i: string; @"?SVG input file path"
    o: string; @"?PNG output file path"
    w: s32; @"?Output file width"
    h: s32; @"?Output file height"
}

main :: () {
    _, args, is_set, _ := parse_arguments(Arguments, Argument_Flags.ALIGN_HELP);
    if (!is_set.i) { print("Missing -i for SVG input file path\n"); exit(1); }
    if (!is_set.o) { print("Missing -o for PNG output file path\n"); exit(1); }
    if (!is_set.w) { print("Missing -w for output image width\n"); exit(1); }
    if (!is_set.h) { print("Missing -h for output image height\n"); exit(1); }

    file_name := args.i;
    output_file_name := args.o;
    width := args.w;
    height := args.h;

    units :: "px";
    dpi : float : 96;
    image := nsvgParseFromFile(file_name.data, "px".data, dpi);

    if (image == null) {
        print("Could not load image.\n");
        exit(1);
    }

    pixels := alloc(width*height*4);

    rasterizer := nsvgCreateRasterizer();

    scale_x := width / image.width;
    scale_y := height / image.height;
    scale := ifx scale_x < scale_y scale_x else scale_y;

    // TODO: upscaling seems to be broken
    // TODO: image will not be centered when input/output image is not square

    print("scaling image: %\n", scale);
    nsvgRasterize(rasterizer, image, 0, 0, scale, pixels, xx image.width, xx image.height, width*4);
    nsvgDeleteRasterizer(rasterizer);

    result := stbi_write_png(output_file_name.data, width, height, 4, pixels, width*4);
    nsvgDelete(image);

    if (result != 0) {
        print("File written: %\n", output_file_name);
    } else {
        print("Image successfully loaded, but failed to convert.\n");
    }
}
