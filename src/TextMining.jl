module TextMining

import Base: getindex, setindex!, isempty, keys, values
import Base: copy, length

export Cluster, DataSet, Distribution 
export FeatureSpace, FeatureVector


abstract FeatureSpace

end
