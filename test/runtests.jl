include("../src/feature_vector.jl")
include("../src/distribution.jl")
include("../src/cluster.jl")
include("../src/clustering.jl")

function run_tests()
  reload("../tests/feature_vector_tests.jl")
  reload("../tests/distribution_tests.jl")
  reload("../tests/cluster_tests.jl")
  reload("../tests/clustering_tests.jl")
end