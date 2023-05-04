### lua-emscripten

This is a simple makefile to build lua for
emscripten.

#### Usage

    # build version 5.4.4 to directory: build/dist/5.4.4/default/
    make 

    # build version 5.4.0 to directory: build/dist/5.4.0/mytag/
    make VERSION=5.4.0 TAG=mytag

    # Show cflags for the specified version/tag
    make cflags
    make cflags VERSION=5.4.0 TAG=mytag

#### Configuration

See the [Makefile](./Makefile) for configuration
options. 
