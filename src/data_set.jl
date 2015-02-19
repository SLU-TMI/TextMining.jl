type DataSet <: FeatureSpace
  clusters::Dict{Any, Cluster}
  DataSet() = new(Dict{Any,Cluster}())
end

# returns the Cluster indexed by [key]
function getindex(ds::DataSet, key)
  return ds.clusters[key]
end

# maps a [key] to a Cluster [c] 
function setindex!(ds::DataSet, c::Cluster, key)
  ds.clusters[key] = c
end

# returns all keys in the DataSet
function keys(ds::DataSet)
  return Base.keys(ds.clusters)
end

# returns all Clusters in the DataSet
function values(ds::DataSet)
  return Base.values(ds.clusters)
end

# check to see if the DataSet is empty.
function isempty(ds::DataSet)
  return Base.isempty(ds.clusters)
end