include("../src/feature_vector.jl")
include("../src/distribution.jl")
include("../src/cluster.jl")
include("../src/clustering.jl")
include("../src/data_set.jl")

function run_tests()
  reload("./test/feature_vector_tests.jl")
  reload("./test/distribution_tests.jl")
  reload("./test/cluster_tests.jl")
  reload("./test/clustering_tests.jl")
  reload("./test/data_set_tests.jl")
end