import Base.isempty

type Distribution{K,V<:Number}
    fv::FeatureVector{K,V}
    total::Number
    Distribution() = new(FeatureVector{Any,Number}(),0)
    Distribution{K,V}(fv::FeatureVector{K,V}) = new(fv,get_total(fv))
    function get_total(fv::FeatureVector)
    	total = 0
    	for value in values(fv)
    		total += value
    	end
    	return total
    end
end
Distribution() = Distribution{Any,Number}()
Distribution{K,V}(fv::FeatureVector{K,V}) = Distribution{K,V}(copy(fv))

function getindex(d::Distribution, key)
  return d.fv.map[key]/d.total
end

function keys(d::Distribution)
  return Base.keys(d.fv.map)
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

function perplexity(d::Distribution)
  return 2^entropy(d)
end

#=
function laplace_smoothing(ds::DataSet)
  unique_keys = 0
  total_keys = 0 
# ADD VECTORS TOGETHER
  for cluster in ds
    for fv in ds 
      if !isempty(fv)
	for key in keys(fv)
	  unique_keys += 1 
	  total_keys += fv[key]
	end
      end
    end
  end
  
end
=#