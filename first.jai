#import "Basic";
#import "Compiler";
#import "Process";

build_nanosvg :: () {
    result := run_command("cc", "-Iinclude", "-c", "src/nanosvg.c", "-o", ".build/nanosvg.o");
    print("run command cc: exit code %\n", result.exit_code);

    result = run_command("ar", "rcs", ".build/libnanosvg.a", ".build/nanosvg.o");
    print("run command ar: exit code %\n", result.exit_code);
}

build :: () {
    set_build_options_dc(.{do_output=false});
    executable_builder_workspace := compiler_create_workspace("svgrastr executable");

    options := get_build_options();
    options.output_executable_name = "svgrastr";
    options.output_type = .EXECUTABLE;

    set_build_options(options, executable_builder_workspace);
    add_build_file("src/main.jai", executable_builder_workspace);
}

#run main();

main :: () {
    build_nanosvg();
    build();
}
