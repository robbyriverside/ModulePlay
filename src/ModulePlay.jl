module ModulePlay

using Dates
include("Uno/Uno.jl")

include("utils.jl")

play() = string("Let's Play! ", Dates.format(Dates.now(), Dates.RFC1123Format))

end # module
