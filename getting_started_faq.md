# Getting Started with Julia Tools

The goal of this document is to get you up to speed using Julia development tools.  The tools are designed in a wonderfully orthogonal way, so you can build whatever workflow you prefer.  But that does not help you when you are starting out.  

This document is organized like an FAQ.  But it is designed to be read from beginning to end for the developer new to Julia.  The FAQ structure also makes it a handy reference.

# The REPL

The REPL (Read Eval Print Loop) is really three tools in one.  It lets you type julia expressions, access the package manager and the system command line.

## 1. Why should I use the REPL?

In a word, speed.  Julia uses a JIT compiler, so if you develop by running your script over and over, you pay the price of compile each time.  The REPL lets you compile the packages once and that makes development go faster.

## 2. How can I use the system command line inside the REPL?

Just type semi-colon (';') and you can use the command line tools (pwd, ls, cd, etc).  This runs a single command and returns to Julia, except for Windows.

    shell> powershell
    shell> exit

If you are using Windows, you will need to type 'powershell' before any commands will work.  But then you have entered the powershell and you will need to type 'exit' to return to Julia.

## 3. How can I use the package manager inside the REPL?

Just type closing square-braket (']') that will drop you into the Pkg manager.  Backspace returns you to the REPL.

## 4. How can I reload packages that have changed inside the REPL?

In a pinch, you can simply exit the REPL and start again.  But there is also the Revise package which tracks your package changes and reloads them for you.  For the module you are developing, you can use include to reload it each time you run your code.  This is explained in the ModulePlay example below.

# Developing Projects

A project is a way of organzing your work for code reuse.  If everything you build is a module, then it could become a public module for others to use or simply organize your work for you to reuse.

## 1. What does a project do?

A project is nothing more than a tree of folders containing your work (code, data, whatever) and two files: Project.toml and Manifest.toml.  These files are located in the root folder of the project, they capture the packages (and package versions) that your code depends upon.  

## 2. Is there a required project organization for files and folders?

No.  Other than the two depdendency files, you can structure it however you wish.  But by following a common package file structure you can later promote your project to be a public package for others to use.

## 3. How do I run my code within a project?

Activating a project will load the dependencies from the Project.toml and Manifest.toml files.  The REPL keeps track of where these files are, so you can add further dependencies to them.

    pkg> activate $HOME/julia/ModulePlay      # activates the example project
    julia --project=$HOME/julia/ModulePlay    # start REPL with ModulePlay project activated

There are two ways for Julia to run within your project and track your project dependencies: the package activate command and passing --project argument to Julia.  In either case, you pass the path to the project, so Julia can locate the Project and Manifest files.

## 4. How do I run my project within current folder?

    pkg> activate .      # activates the project from the current folder (pwd)
    julia --project=.    # start REPL while activating the project in the current folder (pwd)

A common way of using packages is to pass a dot (".") meaning the current folder (pwd).  But that means you need to be inside the project root folder when you call activate or start Julia passing dot to the --project argument.  Once the Julia REPL reads the project files, it knows where they are, so you are not required to stay in the root folder of the project.

## 5. How do I run my project from anywhere inside the project folder tree?

    pkg> activate @.      # activates the project anywhere below the project root folder
    julia --project=@.    # start REPL while activating the project anywhere below the root folder

Another handy way is to activate a project is to pass at-sign dot ("@.") to the activate command or --project argument.  This means if you are anywhere within the project folders it will look up the tree to find the dependency files.  This helps when you don't happen to be in the root folder when you activate.

## 6. What is a good way to start out organizing my project?

    pkg> generate MyModule     # creates the root folder with project file and src folder

The package generate command will create your dependency file (Project.toml) and a src folder under it.  But that is just the first step.  The ModulePlay example (below) provides a simple project organization to get you started.

## 7. How do I incorporate a dependent module into my project?

    pkg> add Dates         # adding the Dates module and its dependencies

The package add command, will place references to the dependent modules into the project and manifest files.  You can also pass the full repo path (ie "gethub/..." ) and it will download the code for you.

# ModulePlay project example

The goal of a project is to develop a single module, which may have many submodules.  When a project is generated, it starts with the module file under the src folder.  For this example it is "src/ModulePlay.jl"

Files and folders of the ModulePlay project:

    /ModulePlay              # root folder
        Project.toml         # project info and dependencies
        Manifest.toml        # dependent modules with versions and related modules
        run.jl               # example script for experimenting with your module
        test.jl              # example script for running the tests for the module
        /src                 # source folder
            ModulePlay.jl    # module definition file
            utils.jl         # example of using multiple source files for a module
            /Uno             # submodule folder
                Uno.jl       # submodule definition file
        /test                # test folder
            runtests.jl      # file for running all module tests (by convention)
            Testing.jl       # Testing module definition
            uno.jl           # submodule tests
            utils.jl         # module tests

This very simple code is designed for you to explore.  You can download it here.

## 1. How can I define my module using multiple source files?

For a very large module you may want to spread the code across multiple files.  These files can be included in the root module file (e.g. ModulePlay.jl).  In the example, we add a utils.jl file which we include in the module.  

The include expression is just like "#include" in C code, it is conceptually the same as if you typed the code in that location.  Everytime it is read, the file contents are loaded into the environment.  So include also doubles as a load function.

## 2. How do I define a submodule within my project?

Add a module file in a subfolder under the src folder.  The ModulePlay example defines a submodule called Uno which is defined in "src/Uno/Uno.jl".  The root module file includes the submodule file.

## 3. How can I write tests for my project?

The standard way of running the tests is using a test folder under the project root directory.  By convention, this contains a "runtests.jl" file.  By including (or loading) that file all the tests for the project should run.

## 4. How can I ensure my tests run outside the module under development?

Add a module file inside the test folder and have the "runtests.jl" file include that module.  Each module creates its own top-level (or main) environment.  The ModulePlay example uses a module called Testing.  Other test files can be used which mirror the structure of the project source files, by including those files in the Testing module.

## 5. Why doesn't ModulePlay use import?

- __using__ you cannot change or extend those module defintions.  Most common way to use a module.
- __import__ allows you to change or extend module defintions.  Make your own variation on an existing module.
- __include__ loads all the module definitions, exported or not.  This is just for your own code or the REPL.

ModulePlay does not extend any defintions from the dependent modules, so it never uses import.  Include is used to load the project code into the ModulePlay module.
