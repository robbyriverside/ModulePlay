# ModulePlay example project

ModulePlay is a simple example of using module tools.  For the full explanation see "getting_started_faq.md".

## Using the REPL

From inside the REPL you can experiment as you create your module using the "run.jl" file.

    julia> include("run.jl)     # assumes you are in the project root folder.

While you develop your tests, the "test.jl" file will run all your tests.

    julia> include("test.jl")

Notice that each of these files loads the latest version of your module, first.

