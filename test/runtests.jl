include("../src/feature_vector.jl")
include("../src/distribution.jl")
include("../src/cluster.jl")
include("../src/clustering.jl")

function run_tests()
  reload("./test/feature_vector_tests.jl")
  reload("./test/distribution_tests.jl")
  reload("./test/cluster_tests.jl")
  reload("./test/clustering_tests.jl")
end