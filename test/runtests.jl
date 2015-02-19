include("../src/TextMining.jl")
include("../src/feature_vector.jl")
include("../src/cluster.jl")
include("../src/data_set.jl")
include("../src/clustering.jl")
include("../src/distribution.jl")

function run_tests()
  reload("./test/feature_vector_tests.jl")
  reload("./test/cluster_tests.jl")
  reload("./test/data_set_tests.jl")
  reload("./test/clustering_tests.jl")
  reload("./test/distribution_tests.jl")
end