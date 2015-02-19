type Distribution{FS<:FeatureSpace}
  space::FS
  unique_keys::Integer
  total::Number
  unk_key::Number
  Distribution() = new(FS(),0,0, 0)
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
  if !haskey(d.space[key])
    return d.unk_key/d.total
  end
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

#add-one smoothing
function smoothing_add_one(d::Distribution{FeatureVector})
  d.total = d.total + (d.unique_keys + 1)
  #standard assumption: +1 to unique_keys to include unknown key in unique_keys
  d.unk_key += 1
  for key in keys(d)
    d[key] += 1
  end
  return d
end

#add-delta smoothing
function smoothing_add_delta(d::Distribution{FeatureVector}, δ::Number=0.1)
  if δ <= 0
    Base.warn("δ must be greater than 0") 
  end
  d.total = d.total + δ*(d.unique_keys + 1)
  d.unk_key += δ
  for key in keys(d)
    d[key] += δ
  end
  return d
end