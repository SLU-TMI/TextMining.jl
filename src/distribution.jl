type Distribution{FS<:FeatureSpace}
  space::FS
  unique_keys::Integer
  total::Number
  Distribution() = new(FS(),0,0)
  Distribution(fv::FeatureVector) = new(fv,length(fv),get_total(fv))
  function get_total(fv::FeatureVector)
    total = 0
    for value in values(fv)
      total += value
    end
    return total
  end
end
Distribution(fv::FeatureVector) = Distribution{FeatureVector}(fv)
Distribution(c::Cluster) = Distribution{Cluster}(c)
Distribution(ds::DataSet) = Distribution{DataSet}(ds)

function getindex(d::Distribution{FeatureVector}, key)
  return d.space[key]/d.total
end

function keys(d::Distribution)
  return keys(d.space)
end

function isempty(d::Distribution)
  return isempty(d.space)
end

function entropy(d::Distribution)
  ent = 0
  for key in keys(d)
    ent -= d[key]*log2(d[key])
  end
  return ent
end

function info_gain(d1::Distribution, d2::Distribution)
  return abs(entropy(d1)-entropy(d2))
end

function perplexity(d::Distribution)
  return 2^entropy(d)
end

# really slow add-1 unigram smoothed probability for target key 
function laplace_smoothed_prob(ds::Distribution, target)
  unique_keys = 0
  total_keys = 0
  ds_fv = FeatureVector() #will be feature vector of entire data set
  for cluster in ds
    if !isempty(cluster)
      ds_fv += cluster.vector_sum
    end
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


# add-1 smoothing that returns a giant feature vector of the data set with new counts
function laplace_smoothing(ds::Distribution)
  unique_keys = 0
  total_keys = 0
  ds_fv = FeatureVector() #will be feature vector of entire data set
  for cluster in ds
    if !isempty(cluster)
      ds_fv += cluster.vector_sum
    end
  end
  for key in keys(ds_fv)
    unique_keys += 1
    total_keys += ds_fv[key]
  end
  ds_fv["<UNK>"] = 0       #placeholder for "unknown" key that is not present in data set
  for key in keys(ds_fv)
    ds_fv[key] = (ds_fv[key] + 1) * (total_keys / (total_keys + unique_keys))
  end 
  return ds_fv
end