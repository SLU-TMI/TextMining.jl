type Distribution{FS<:FeatureSpace}
  space::FS
  features::Number
  total::Number
  smooth::Function
  smooth_data::Array
  mdata::Any
  Distribution() = new(FS(),0,0,_no_smoothing,[])
  Distribution(fv::FeatureVector) = new(fv,length(fv),get_total(fv),_no_smoothing,[])
  Distribution(c::Cluster) = new(c,length(c.vector_sum),get_total(c.vector_sum) ,_no_smoothing,[])
  Distribution(ds::DataSet) = new(ds,length(ds.vector_sum),get_total(ds.vector_sum) ,_no_smoothing,[])
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

function getindex(d::Distribution, key)
  return d.space[key]
end

function probability(d::Distribution, feature)
  return d.smooth(d, feature, d.smooth_data)
end

function prob_fv(d::Distribution{Cluster}, key)
  return d.space[key].total / d.total
end

function prob_fv(d::Distribution{DataSet}, clust_key, key)
  return d.space[clust_key][key].total / d.total
end

function prob_cl(d::Distribution{DataSet}, key)
  return d.space[key].vector_sum.total / d.total
end

function cond_prob_f_given_fv(d::Distribution{Cluster}, fv_key, key)
  return d.space[fv_key][key] / d.space[fv_key].total
end

function cond_prob_f_given_fv(d::Distribution{DataSet}, clust_key, fv_key, key)
  return d.space[clust_key][fv_key][key] / d.space[clust_key][fv_key].total
end

function cond_prob_f_given_clust(d::Distribution{DataSet}, clust_key, key)
  return d.space[clust_key].vector_sum[key] / d.space[clust_key].vector_sum.total
end

function cond_prob_fv_given_clust(d::Distribution{DataSet}, clust_key, key)
  return d.space[clust_key][key].total / d.space[clust_key].vector_sum.total
end

function keys(d::Distribution)
  return keys(d.space)
end

function features(d::Distribution{FeatureVector})
  return keys(d.space)
end

function features(d::Distribution)
  return keys(d.space.vector_sum)
end

function isempty(d::Distribution)
  return isempty(d.space)
end

function entropy(d::Distribution)
  ent = 0
  for feature in features(d)
    ent -= probability(d,feature)*log2(probability(d,feature))
  end
  return ent
end

function fv_entropy(d::Distribution{Cluster})
  ent = 0
  for fv in keys(d.space)
    ent -= prob_fv(d,fv)*log2(prob_fv(d,fv))
  end
  return ent
end

function fv_entropy(d::Distribution{DataSet})
  ent = 0
  for clust in keys(d.space)
    for fv in keys(d.space[clust])
      ent -= prob_fv(d,clust,fv)*log2(prob_fv(d,clust,fv))
    end
  end
  return ent
end

function fv_entropy(d::Distribution{DataSet}, clust_key)
  ent = 0
  for fv in keys(d.space[clust_key])
    ent -= prob_fv(d,clust_key,fv)*log2(prob_fv(d,clust_key,fv))
  end
  return ent
end

function clust_entropy(d::Distribution{DataSet})
  ent = 0
  for clust in keys(d.space)
    ent -= prob_cl(d,clust)*log2(prob_cl(d,clust))
  end
  return ent
end

function info_gain(d1::Distribution{FeatureVector}, d2::Distribution{FeatureVector})
  return entropy(d1)-entropy(d2)
end

function info_gain(d1::Distribution{Cluster}, d2::Distribution{Cluster})
  return entropy(d1)-entropy(d2)
end

function info_gain(d1::Distribution{DataSet}, d2::Distribution{DataSet})
  return entropy(d1)-entropy(d2)
end

# function fv_info_gain_clust(d1::Distribution{Cluster}, d2::Distribution{Cluster})
#   return fv_entropy(d1)-fv_entropy(d2)
# end

# function fv_info_gain_dataset(d1::Distribution{DataSet}, d2::Distribution{DataSet}, clust_key)
#   return fv_entropy(d1, clust_key)-fv_entropy(d2,clust_key)
# end

# function clust_info_gain_dataset(d1::Distribution{DataSet}, d2::Distribution{DataSet})
#   return clust_entropy(d1, clust_key)-clust_entropy(d2,clust_key)
# end

function perplexity(d::Distribution)
  return 2^entropy(d)
end

function display(dist::Distribution)
  display(dist.space)
end

#helper function that sets the smoothing type
function set_smooth!(d::Distribution{FeatureVector}, f::Function, sd::Array)
  d.smooth = f
  d.smooth_data = sd
end

#no smoothing default
function remove_smoothing!(d::Distribution)
  set_smooth!(d,_no_smoothing,[])
end

function _no_smoothing(d::Distribution{FeatureVector}, key, data::Array)
  return d.space[key] / d.total
end

function _no_smoothing(d::Distribution, feature, data::Array)
  return d.space.vector_sum[feature] / d.total
end

#add-delta smoothing, defaults to add-one smoothing
function delta_smoothing!(d::Distribution, δ::Number=1)
  if δ <= 0
    Base.warn("δ must be greater than 0") 
  end
  set_smooth!(d,_δ_smoothing,[δ,d.features,d.total])
end

function _δ_smoothing(d::Distribution{FeatureVector}, key, data::Array)
  if !haskey(d.space, key)
    return (data[1])/(data[1]*(data[2]+1)+data[3])
  end
  return (d.space[key]+data[1])/(data[1]*(data[2]+1)+data[3])
end

function _δ_smoothing(d::Distribution, key, data::Array)
  if !haskey(d.space.vector_sum, key)
    return (data[1])/(data[1]*(data[2]+1)+data[3])
  end
  return (d.space[key]+data[1])/(data[1]*(data[2]+1)+data[3])
end

#simple good-turing smoothing
function goodturing_smoothing!(d::Distribution{FeatureVector})
  freqs = FeatureVector() 
  for value in values(d.space)
    freqs[value] += 1
  end
  set_smooth!(d,_gt_smoothing, [d.total, freqs])
end

function goodturing_smoothing!(d::Distribution)
  freqs = FeatureVector() 
  for value in values(d.space.vector_sum)
    freqs[value] += 1
  end
  set_smooth!(d,_gt_smoothing, [d.total, freqs])
end

function _gt_smoothing(d::Distribution{FeatureVector}, key, data::Array)
  if !haskey(d.space, key)
    return data[2][1] / data[1] #num of keys that occur once / total number of keys
  end
  c = d.space[key]
  c_adjust = (c+1) * (data[2][c+1]/data[2][c])
  return c_adjust / data[1]
end

function _gt_smoothing(d::Distribution, key, data::Array)
  if !haskey(d.space.vector_sum, key)
    return data[2][1] / data[1] #num of keys that occur once / total number of keys
  end
  c = d.space.vector_sum[key]
  c_adjust = (c+1) * (data[2][c+1]/data[2][c])
  return c_adjust / data[1]
end