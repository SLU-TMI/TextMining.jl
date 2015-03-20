using TextMining
using FactCheck
using Compat

path = pwd()
cd("..")
reload("./test/feature_vector_tests.jl")
reload("./test/cluster_tests.jl")
reload("./test/data_set_tests.jl")
reload("./test/clustering_tests.jl")
reload("./test/distribution_tests.jl")
cd(path)
