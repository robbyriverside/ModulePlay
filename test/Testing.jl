module Testing

include("../src/ModulePlay.jl")

using Test

using ModulePlay

@Test.testset "play tests" begin
    @Test.test startswith(ModulePlay.play(), "Let's Play! ")
end

include("utils.jl")

include("uno.jl")

end # module Testing