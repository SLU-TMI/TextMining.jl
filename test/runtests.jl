using FactCheck

include("../src/TextMining.jl")

function run_tests()
  reload("./test/feature_vector_tests.jl")
  reload("./test/cluster_tests.jl")
  reload("./test/data_set_tests.jl")
  reload("./test/clustering_tests.jl")
  reload("./test/distribution_tests.jl")
end

run_tests()