type Cluster <: FeatureSpace
  vectors::Dict{Any, FeatureVector}
  vector_sum::FeatureVector
  mdata::Any
  Cluster() = new(Dict{Any,FeatureVector}(),FeatureVector())
end

# returns FeatureVector indexed by [key]
function getindex(c::Cluster, key)
  return c.vectors[key]
end

# maps a [key] to a FeatureVector [fv] 
function setindex!(c::Cluster, fv::FeatureVector, key)
  if haskey(c, key)
    subtract!(c.vector_sum,c[key])
  end
  add!(c.vector_sum,fv)
  c.vectors[key] = fv
end

function length(c::Cluster)
  return Base.length(c.vectors)
end

# returns all keys in the cluster
function keys(c::Cluster)
  return Base.keys(c.vectors)
end

# returns all FeaturVectors in the cluster
function values(c::Cluster)
  return Base.values(c.vectors)
end

# check to see if the Cluster is empty.
function isempty(c::Cluster)
  return Base.isempty(c.vectors)
end

# returns cluster centroid
function centroid(c::Cluster)
  return c.vector_sum/length(c)
end

# returns the distance between the centroids of the provided clusters
function distance(c1::Cluster, c2::Cluster, dist::Function = dist_cos)
  return dist(centroid(c1),centroid(c2))
end

function haskey(c::Cluster, key) 
  return Base.haskey(c.vectors, key)
end