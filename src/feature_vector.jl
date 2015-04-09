#= 
# Type definition for a FeatureVector.
# Wrapper around a Dict type.
# Restricted to Any type [key] => [value] of Number type.
=#
 
type FeatureVector{K,V<:Number} <: FeatureSpace
  map::Dict{K,V}
  total::Number
  length::Number
  mdata::Any
  FeatureVector() = new(Dict{K,V}(),0,0)
  FeatureVector{K,V}(map::Dict{K,V}) = new(map,get_total(map),get_length(map))
  function get_total(fv::Dict{K,V})
    total = 0
    for value in values(fv)
      total += value
    end
    return total
  end
  function get_length(fv::Dict{K,V})
    length = 0
    for value in values(fv)
      length += value^2
    end
    return sqrt(length)
  end
end
FeatureVector() = FeatureVector{Any,Number}()
FeatureVector{K,V}(map::Dict{K,V}) = FeatureVector{K,V}(sanitize!(Base.copy(map)))

# gets value of [key] in a FeatureVector
function getindex(fv::FeatureVector, key)
  if haskey(fv,key)
    return fv.map[key]
  end
  return 0
end

# sets value of [key] in a FeatureVector. Must be subtype of number/dict type
function setindex!(fv::FeatureVector, value, key)
  fv.total -= fv[key]
  fv.total += value
  
  fv.length = sqrt((fv.length^2-fv[key]^2)+value^2)
  
  if value == 0
    Base.delete!(fv.map, key)
  else
    fv.map[key] = value
  end
end

# gets all keys of a FeatureVector
function keys(fv::FeatureVector)
  return Base.keys(fv.map)
end

# gets all values of a FeaturVector
function values(fv::FeatureVector)
  return Base.values(fv.map)
end

# check to see if the FeatureVector is empty.
function isempty(fv::FeatureVector)
  return Base.isempty(fv.map)
end

# check to see if the FeatureVector has key.
function haskey(fv::FeatureVector, key)
  return Base.haskey(fv.map,key)
end

# returns length of FeatureVector
function length(fv::FeatureVector)
  return Base.length(fv.map)
end

# copies selected fv, and makes a new one.
function copy{K,V}(fv::FeatureVector{K,V})
  new_fv = FeatureVector{K,V}()

  for key in keys(fv)
    new_fv[key] = fv[key]
  end

  return new_fv
end

# deletes 0 value keys in a dictionary
function sanitize!(dict::Dict)
  for key in keys(dict)
    if dict[key] == 0
      Base.delete!(dict,key)
    end
  end
  return dict
end

# returns an Array of the (key, value) tuples
# in fv using the provided boolean expression
# by default it sorts by largest value
function freq_list(fv::FeatureVector, expression::Function = (a,b) -> a[2]>b[2])
  words = Array(find_common_type(fv,fv),length(fv))
  i = 1
  for word in fv.map
    words[i] = word
    i+=1
  end
  return Base.sort!(words,lt=expression)
end

# finds common type of two FeatureVectors 
function find_common_type(fv1::FeatureVector,fv2::FeatureVector)
  if isempty(fv1) && isempty(fv2)
    commonType = (Any,Number)
  elseif isempty(fv1)
    commonType = typeof(first(fv2.map))
  elseif isempty(fv2)
    commonType = typeof(first(fv1.map))
  else
    fv1_type = typeof(first(fv1.map))
    fv2_type = typeof(first(fv2.map))
    commonType = (promote_type(fv1_type[1],fv2_type[1]),
    promote_type(fv1_type[2],fv2_type[2]))
  end

  return commonType
end

# adds two FeatureVectors together
function +(fv1::FeatureVector, fv2::FeatureVector)
  dict_type = find_common_type(fv1,fv2)
  dict = Dict{dict_type[1],dict_type[2]}(fv1.map)
  fv1_keys = keys(fv1)
  fv2_keys = keys(fv2)
  
  for key in fv2_keys
    if key in fv1_keys
      dict[key] += fv2[key]
    else
      dict[key] = fv2[key]
    end
  end
  
  return FeatureVector(dict)
end

# adds two FeatureVectors together in place
function add!(fv1::FeatureVector, fv2::FeatureVector)
  for key in keys(fv2)
      fv1[key] += fv2[key]
  end
end

# subtracts two FeatureVectors
function -(fv1::FeatureVector, fv2::FeatureVector)
  dict_type = find_common_type(fv1,fv2)
  dict = Dict{dict_type[1],dict_type[2]}(fv1.map)
  fv1_keys = keys(fv1)
  fv2_keys = keys(fv2)

  for key in fv2_keys
    if key in fv1_keys
      dict[key] -= fv2[key]
    else
      dict[key] = -fv2[key]
    end
  end

  return FeatureVector(dict)
end

# subtracts two FeatureVectors in place
function subtract!(fv1::FeatureVector, fv2::FeatureVector)
  for key in keys(fv2)
      fv1[key] -= fv2[key]
  end
end

# multiplies a FeatureVector by a scalar
function *(fv::FeatureVector, value::Number)
  if isempty(fv)
    return fv
  end

  fv_keys = keys(fv)
  fv_type = typeof(first(fv.map)[2])
  dict = Dict{typeof(first(fv_keys)), promote_type(fv_type,typeof(value))}()

  for key in fv_keys
    dict[key] = fv[key]*value
  end

  return FeatureVector(dict)
end

# handles commutativity of multiplication
function *(value::Number, fv::FeatureVector)
  return fv*value
end

# in place multiplication by a scalar
function multiply!(fv::FeatureVector, value::Number)
  for key in keys(fv)
    fv[key] = fv[key]*value
  end
end

# divides a FeatureVector by a scalar
function /(fv::FeatureVector, value::Number)
  if isempty(fv)
    return fv
  end

  fv_keys = keys(fv)
  dict = Dict{Any, typeof(fv[first(fv_keys)]/value)}()
  
  for key in fv_keys
    dict[key] = fv[key]/value
  end

  return FeatureVector(dict)
end

# in place division by a scalar
function divide!(fv::FeatureVector, value::Number)
  for key in keys(fv)
    fv[key] = fv[key]/value
  end
end

# rationalizes a FeatureVectors values
function //(fv::FeatureVector, value::Integer)
  if isempty(fv)
    return fv
  end

  fv_keys = keys(fv)
  dict = Dict{typeof(first(fv_keys)), Rational}()
  for key in fv_keys
    dict[key] = fv[key]//value
  end

  return FeatureVector(dict)
end

# in place rationalization by a scalar
function rationalize!(fv::FeatureVector, value::Integer)
  for key in keys(fv)
    fv[key] = fv[key]//value
  end
end

# finds the cosine between two vectors and returns 1-cos
function dist_cos(fv1::FeatureVector, fv2::FeatureVector, norm::Bool=false)
  fv1_magnitude = 0
  fv2_magnitude = 0
  dot_product = 0

  for key in keys(fv1)
    fv1_value = fv1[key]
    fv1_magnitude += fv1_value*fv1_value
    dot_product += fv1_value*fv2[key]
  end

  for key in keys(fv2)
    fv2_value = fv2[key]
    fv2_magnitude += fv2_value*fv2_value
  end

  cosine = dot_product/(sqrt(fv1_magnitude)*sqrt(fv2_magnitude))
  if cosine > 1 - 1e-15
    cosine = 1
  end

  return 1 - cosine
end

# number of disjoint nonzero dimensions between vectors
function dist_zero(fv1::FeatureVector, fv2::FeatureVector, norm::Bool=false)
  distance = 0

  for key in keys(fv1)
    if fv1[key] != 0 && fv2[key] == 0
      distance += 1
    end
  end

  for key in keys(fv2)
    if fv2[key] != 0 && fv1[key] == 0
      distance += 1
    end
  end

  return distance
end

# zero distance divided by number of dimensions
function dist_zero_weighted(fv1::FeatureVector, fv2::FeatureVector, norm::Bool=false)
  d1 = 0
  d2 = 0
  l1 = 0
  l2 = 0

  for key in keys(fv1)
    if fv1[key] != 0 
      l1 += 1
      if fv2[key] == 0
	d1 += 1
      end
    end
  end

  for key in keys(fv2)
    if fv2[key] != 0 
      l2 += 1
      if fv1[key] == 0 
	d2 += 1
      end
    end
  end

  return d1/l1 + d2/l2
end

# sum of absolute distance between dimensions
function dist_taxicab(fv1::FeatureVector, fv2::FeatureVector, norm::Bool = true)
  distance = 0

  for key in keys(fv1)
    if norm
      distance += abs((fv1[key]/fv1.total)-(fv2[key]/fv2.total))
    else
      distance += abs(fv1[key]-fv2[key])
    end
  end

  for key in keys(fv2)
    if !haskey(fv1, key)
      if norm
        distance += abs(fv2[key]/fv2.total)
      else
        distance += abs(fv2[key])
      end
    end
  end

  return distance
end

# ordinary distance between vectors
function dist_euclidean(fv1::FeatureVector, fv2::FeatureVector, norm::Bool = true)
  distance = 0

  for key in keys(fv1)
    if norm
      distance += ((fv1[key]/fv1.length)-(fv2[key]/fv2.length))^2
    else
      distance += (fv1[key]-fv2[key])^2
    end
  end

  for key in keys(fv2)
    if !haskey(fv1, key)
      if norm
        distance += (fv2[key]/fv2.length)^2
      else
        distance += fv2[key]^2
      end
    end
  end

  return sqrt(distance)
end

# maximum absolute difference between dimensions
function dist_infinite(fv1::FeatureVector, fv2::FeatureVector, norm::Bool = true)
  max_dist = 0
  max_fv1 = 0
  max_fv2
  if norm
    for value in values(fv1)
      if value > max_fv1
        max_fv1 = value
      end
    end
    for value in values(fv2)
      if value > max_fv2
        max_fv2 = value
      end
    end 
  end

  for key in keys(fv1)
    if norm
      current_dist = abs((fv1[key]/max_fv1)-(fv2[key]/max_fv2))
    else
      current_dist = abs(fv1[key]-fv2[key])
    end

    if current_dist > max_dist
      max_dist = current_dist
    end
  end

  for key in keys(fv2)
    current_dist = 0
    if !haskey(fv1, key)
      if norm
        current_dist = abs(fv2[key]/max_fv2)
      else
        current_dist = abs(fv2[key])
      end
    end
    if current_dist > max_dist
      max_dist = current_dist
    end
  end

  return max_dist
end


# prints out the fv cleanly.
function display(fv::FeatureVector)
  print_with_color(:white,string(typeof(fv)))
  fv_list = freq_list(fv)
  k = length(fv_list)
  print_with_color(:white," with $k features")
  if k > 0
    print_with_color(:white,":\n")
    if k > 5
      k = 5
    end

    print_with_color(:white,"  Top $k Features:\n")
    for key in fv_list[1:k]
      print_with_color(:white,"    $key\n")
    end
  end
end

function show(io::IO, fv::FeatureVector)
  print(io,string(typeof(fv)))
  k = length(fv.map)
  print(io," with $k features")
end