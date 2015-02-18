type DataSet
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

# really slow add-1 unigram smoothed probability for target key 
function laplace_smoothed_prob(ds::DataSet, target)
  unique_keys = 0
  total_keys = 0
  ds_fv = FeatureVector() #will be feature vector of entire data set
  for cluster in ds
    if !isempty(cluster)
      ds_fv += cluster.vector_sum
    end
  for key in keys(ds_fv)
    unique_keys += 1
    total_keys += ds_fv[key]
  end
  if !haskey(ds_fv, target)
    return 1 / (total_keys + unique_keys) 
  end
  return (ds_fv[target] + 1) / (total_keys + unique_keys) 
end

#add-1 smoothing that returns a giant feature vector of the data set with new counts
function laplace_smoothing(ds::DataSet)
  unique_keys = 0
  total_keys = 0
  ds_fv = FeatureVector() #will be feature vector of entire data set
  for cluster in ds
    if !isempty(cluster)
      ds_fv += cluster.vector_sum
    end
  for key in keys(ds_fv)
    unique_keys += 1
    total_keys += ds_fv[key]
  end
  ds_fv["<UNK>"] = 0       #placeholder for "unknown" key that is not present in data set
  for key in keys(ds_fv)
    ds_fv[key] = (ds_fv[key] + 1) * (total_keys / ((total_keys + unique_keys))
  end 
  return ds_fv
end