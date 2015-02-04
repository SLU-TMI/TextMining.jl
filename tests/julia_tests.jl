include("../src/feature_vector.jl")
include("../src/distribution.jl")

function runTests()
		reload("../tests/feature_vector_tests.jl")
		reload("../tests/distribution_tests.jl")
end