# module TextMining

import Base: getindex, setindex!, isempty, keys, values,
             copy, length, haskey

abstract FeatureSpace

include("feature_vector.jl")
include("cluster.jl")
include("data_set.jl")
include("clustering.jl")
include("distribution.jl")
include("text_processing.jl")

# export #types
#        Cluster, DataSet, Distribution FeatureSpace, FeatureVector

       #functions
# end
