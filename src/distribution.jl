type Distribution{FS<:FeatureSpace}
  space::FS
  features::Number
  total::Number
  smooth::Function
  smooth_data::Array
  mdata::Any
  Distribution() = new(FS(),0,0,_no_smoothing,[])
  Distribution(fv::FeatureVector) = new(fv,length(fv),get_total(fv),_no_smoothing,[])
  Distribution(c::Cluster) = new(c,length(c.vector_sum),get_total(c.vector_sum),_no_smoothing,[])
  Distribution(ds::DataSet) = new(ds,length(ds.vector_sum),get_total(ds.vector_sum),_no_smoothing,[])
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

function _no_smoothing(d::Distribution, key, data::Array)
  return d.space[key] / d.total
end

#add-delta smoothing, default to add-one smoothing
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