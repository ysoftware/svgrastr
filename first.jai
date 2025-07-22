#import "Basic";
#import "Compiler";

build :: () {
    set_build_options_dc(.{do_output=false});
    executable_builder_workspace := compiler_create_workspace("svgrastr executable");

    options := get_build_options();
    options.output_executable_name = "svgrastr";
    options.output_type = .EXECUTABLE;

    set_build_options(options, executable_builder_workspace);
    add_build_file("main.jai", executable_builder_workspace);
}

#run build();
