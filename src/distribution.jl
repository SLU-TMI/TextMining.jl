type Distribution{FS<:FeatureSpace}
  space::FS
  total::Number
  smooth::Function
  smooth_data::Array
  mdata::Any
  Distribution() = new(FS(),0,_no_smoothing,[])
  Distribution(fv::FeatureVector) = new(fv,get_total(fv),_no_smoothing,[]) 
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
  return d.smooth(d, key, d.smooth_data)
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

function set_smooth!(d::Distribution{FeatureVector}, f::Function, sd::Array)
  d.smooth = f
  d.smooth_data = sd
end

#no smoothing default
function remove_smoothing!(d::Distribution)
  set_smooth!(d,_no_smoothing,[])
end

function _no_smoothing(d::Distribution, key, data::Array)
  return d.space[key] / d.total
end

#add-delta smoothing, defaults to add-one smoothing
function delta_smoothing!(d::Distribution, δ::Number=1)
  if δ <= 0
    Base.warn("δ must be greater than 0") 
  end
  unique = length(d.space)
  set_smooth!(d,_δ_smoothing,[δ,unique,d.total])
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
