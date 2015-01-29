import Base.isempty

type Distribution{K,V<:Rational}
    fv::FeatureVector{K,V}
    #total::Number - TODO use to normalize dist to sum to 1
    Distribution() = new(FeatureVector{Any,Rational}())
    Distribution{K,V}(fv::FeatureVector{K,V}) = new(fv)
end
Distribution() = Distribution{Any,Rational}()
Distribution(fv::FeatureVector) = Distribution{Any,Rational}(norm(fv))

function norm(d::Distribution)
#TODO - modify values so dist sums to 1
end

function getindex(d::Distribution, key)
  return d.fv.map[key]
end

function setindex!(d::Distribution, value::Number, key)
    d.fv.map[key] = value
    norm(d)
end

function keys(d::Distribution)
  return Base.keys(d.fv.map)
end

function values(d::Distribution)
  return Base.values(d.fv.map)
end

function isempty(d::Distribution)
    return Base.isempty(d.fv.map)
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