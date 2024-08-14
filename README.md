# cpp-oj-template
This project helps oj programming

# Prerequisite

1. installed `make` and `c++ compiler`
2. set path and compile flags in `Makefile`
3. run `make init`

# Usages

To create and run test examples.
> make test

To diff between actual output and expected output.
> make diff

To add new test examples.
> make mkex

To simply compile and run with examples
> make

# Specify the number of test examples
Usages above can run with a variable specifying the identity of examples.
> make [run|test|diff|mkex] num=[1|2|abc]

If there is no such file, it will be created. If there exists such a file, it will be truncated and used to store new data.

# compile_commands.json
`compile_commands.json` was generated under `build` when running `make init` and can be used by clangd and other tools.