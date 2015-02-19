# module TextMining

import Base: getindex, setindex!, isempty, keys, values,
             copy, length

abstract FeatureSpace

include("feature_vector.jl")
include("cluster.jl")
include("data_set.jl")
include("clustering.jl")
include("distribution.jl")

# export #types
#        Cluster, DataSet, Distribution FeatureSpace, FeatureVector

       #functions
# end
