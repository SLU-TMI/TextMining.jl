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

function info_gain(d1::Distribution, d2::Distribution)
  return entropy(d1)-entropy(d2)
end

function perplexity(d::Distribution)
  return 2^entropy(d)
end

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

<<<<<<< HEAD
#add-delta smoothing, defaults to add-one smoothing
=======
function _no_smoothing(d::Distribution, feature, data::Array)
  return d.space.vector_sum[feature] / d.total
end

#add-delta smoothing, default to add-one smoothing
>>>>>>> master
function delta_smoothing!(d::Distribution, δ::Number=1)
  if δ <= 0
    Base.warn("δ must be greater than 0") 
  end
  set_smooth!(d,_δ_smoothing,[δ,d.features,d.total])
end

function _δ_smoothing(d::Distribution, key, data::Array)
  if !haskey(d.space, key)
    return (data[1])/(data[1]*(data[2]+1)+data[3])
  end
  return (d.space[key]+data[1])/(data[1]*(data[2]+1)+data[3])
end

#=simple good-turing smoothing
function goodturing_smoothing!(d::Distribution)
  #need frequencies of frequencies here
  #aka there are 120 words that occur 1 time, 20 words that occur 2 times, etc
  set_smooth!(d,_gt_smoothing, [d.total, #frequencies])
end

function _gt_smoothing(d::Distribution, key, data::Array)
  if !haskey(d.space, key)
  #return "number of words that occur once" / data[1]
  end
  #return distribution smoothed by good-turing, see papers
=#
