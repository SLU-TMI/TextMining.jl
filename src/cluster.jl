type Cluster
    clust::Dict
    centroid::FeatureVector
end

# returns FeatureVector indexed by [key]
function getindex(c::Cluster, key)
  return c.clust[key]
end

# maps a string [key] to a FeatureVector [fv] 
function setindex!(c::Cluster, fv::FeatureVector, key)
  if haskey(c.clust, key)
    c.centroid - c.clust[key]
  end
  c.centroid + fv
  c.clust[key] = fv
end

# returns all keys in the cluster
function keys(c::Cluster)
  return Base.keys(c.clust)
end

# returns all FeaturVectors in the cluster
function values(fv::FeatureVector)
  return Base.values(fv.map)
end

# check to see if the Cluster is empty.
function isempty(fv::FeatureVector)
    return Base.isempty(fv.map)
end

# returns cluster centroid
function centroid(c::Cluster)
  return c.centroid/length(c.clust)
end
