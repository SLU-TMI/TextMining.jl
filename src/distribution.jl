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

function get_num_texts_in_dist(d::Distribution{DataSet})
  texts = 0
  for clust in values(d.space.clusters)
    texts += length(clust)
  end
  return texts
end

function get_num_texts_given_feature(d::Distribution{DataSet}, feature)
  texts = 0
  for clust in values(d.space.clusters)
    for fv in values(clust.vectors)
      if haskey(fv,feature)
        texts += 1
      end
    end
  end
  return texts
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

function cond_prob_f_given_fv_in_clust(d::Distribution{DataSet}, clust_key, fv_key, key)
  return d.space[clust_key][fv_key][key] / d.space[clust_key].vector_sum[key]
end

function cond_prob_f_given_clust(d::Distribution{DataSet}, clust_key, key)
  return d.space[clust_key].vector_sum[key] / d.space[clust_key].vector_sum.total
end

function cond_prob_fv_given_clust(d::Distribution{DataSet}, clust_key, key)
  return d.space[clust_key][key].total / d.space[clust_key].vector_sum.total
end

# new scannell stuff
function prob_clust_in_dataset(d::Distribution{DataSet}, clust_key)
  return length(d.space[clust_key].vectors) / get_num_texts_in_dist(d)
end

function prob_clust_given_feature(d::Distribution{DataSet}, clust_key, feature)
  num_fvs = 0
  prob = 0
  for fv in values(d.space.clusters[clust_key])
    if haskey(fv,feature)
      num_fvs += 1
    end
  end
  prob = num_fvs / get_num_texts_given_feature(d,feature)
  return prob
end

# end scannell stuff


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

function feature_entropy(d::Distribution{Cluster},feature)
  ent = 0
  for fv in keys(d.space.vectors)
    x = cond_prob_f_given_fv(d,fv,feature)*log2(cond_prob_f_given_fv(d,fv,feature))
    if isnan(x)
      x = 0
    end
    ent -= x
  end
  return ent
end

function feature_entropy(d::Distribution{DataSet},feature)
  ent = 0
  for clust in keys(d.space.clusters)
    x = cond_prob_f_given_clust(d,clust,feature)*log2(cond_prob_f_given_clust(d,clust,feature))
    if isnan(x)
      x = 0
    end
    ent -= x
  end
  return ent
end

# scannell
function clust_in_dataset_entropy(d::Distribution{DataSet})
  ent = 0
  for clust in keys(d.space)
    x = prob_clust_in_dataset(d,clust)*log2(prob_clust_in_dataset(d,clust))
    if isnan(x)
      x = 0
    end
    ent -= x
  end
  return ent
end

function clust_given_feature_entropy(d::Distribution{DataSet},feature)
  ent = 0
  for clust in keys(d.space)
    x = prob_clust_given_feature(d,clust,feature)*log2(prob_clust_given_feature(d,clust,feature))
    if isnan(x)
      x = 0
    end
    ent -= x
  end
  return ent
end

function clust_info_gain(d1::Distribution{DataSet}, feature, weight::Bool=false)
  ent_of_dist = clust_in_dataset_entropy(d1)
  ent_of_word = clust_given_feature_entropy(d1, feature)
  if weight
    return (ent_of_dist - ent_of_word)/ent_of_dist
  end
  return ent_of_dist - ent_of_word
end

function chi_info_gain(d::Distribution{DataSet},feature)
  all_ig = 0
  for clust in keys(d.space.clusters)
    child_ig = 0
    f_in_clust_ent = 0
    for fv in keys(d.space[clust].vectors)
      prob = cond_prob_f_given_fv_in_clust(d,clust,fv,feature)
      x = (prob*log2(prob))
      if isnan(x)
        x = 0
      end
      f_in_clust_ent -= x
    end
    child_ig = clust_in_dataset_entropy(d) - f_in_clust_ent
    all_ig += child_ig*prob_clust_given_feature(d,clust,feature)
  end
  return clust_info_gain(d,feature) - all_ig
end
# end scannell

function info_gain(d1::Distribution, d2::Distribution)
  return entropy(d1)-entropy(d2)
end

function feature_info_gain(d1::Distribution, word)
  return entropy(d1)-feature_entropy(d1, word)
end

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