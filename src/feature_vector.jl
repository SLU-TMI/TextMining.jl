type FeatureVector
    map::Dict
    FeatureVector() = new(Dict())
    FeatureVector(map::Dict) = new(map)
end

function loadFeatureVector(array)
    fv = FeatureVector()
    for word in array
        if word in keys(fv)
            fv[word] += 1
        else
            setindex!(fv,1,word)
        end
    end
    return fv
end

function getindex(fv::FeatureVector, key)
  return fv.map[key]
end

function setindex!(fv::FeatureVector, value::Number, key)
    fv.map[key] = value
end

function keys(fv::FeatureVector)
  return Base.keys(fv.map)
end

function values(fv::FeatureVector)
  return Base.values(fv.map)
end

function +(fv1::FeatureVector, fv2::FeatureVector)
    dict = copy(fv1.map)
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

function -(fv1::FeatureVector, fv2::FeatureVector)
    dict = copy(fv1.map)
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

function /(fv::FeatureVector, value::Number)
    fv_keys = keys(fv)
    dict = Dict{typeof(first(fv_keys)), Number}()
    for key in fv_keys
	dict[key] = fv[key]/value
    end
    return FeatureVector(dict)
end

function //(fv::FeatureVector, value::Number)
    fv_keys = keys(fv)
    dict = Dict{typeof(first(fv_keys)), Rational}()
    for key in fv_keys
	dict[key] = fv[key]//value
    end
    return FeatureVector(dict)
end

function cos_similarity(fv1::FeatureVector, fv2::FeatureVector)
    fv1_keys = keys(fv1)
    fv2_keys = keys(fv2)
    fv1_magnitude = 0
    fv2_magnitude = 0
    dot_product = 0

    for key in fv1_keys
        fv1_value = fv1[key]
        fv1_magnitude += fv1_value*fv1_value
        if key in fv2_keys
            dot_product += fv1_value*fv2[key]
        end
    end

    for key in fv2_keys
        fv2_value = fv2[key]
        fv2_magnitude += fv2_value*fv2_value
    end

    cosine = dot_product/(sqrt(fv1_magnitude)*sqrt(fv2_magnitude))
    cosine = 1 - cosine
    return cosine
end

function zero_dist(fv1::FeatureVector, fv2::FeatureVector)
    fv1_keys = keys(fv1)
    fv2_keys = keys(fv2)
    distance = 0

    for key in fv1_keys
        if key in fv2_keys
            distance += abs(fv1[key]-fv2[key])
        end
    end
    return distance
end

function manhattan_dist(fv1::FeatureVector, fv2::FeatureVector)
    fv1_keys = keys(fv1)
    fv2_keys = keys(fv2)
    distance = 0

    for key in fv1_keys
        if key in fv2_keys
            distance += abs(fv1[key]-fv2[key])
        else
            distance += abs(fv1[key])
        end
    end

    for key in fv2_keys
        if fv1[key] == 0
            distance += abs(fv2[key])
        end
    end
    return distance
end

function euclidean_dist(fv1::FeatureVector, fv2::FeatureVector)
    fv1_keys = keys(fv1)
    fv2_keys = keys(fv2)
    distance = 0
    value = 0

    for key in fv1_keys
        if key in fv2_keys
            value = fv1[key]-fv2[key]
        else
            value = fv1[key]
        end
        distance += value*value
    end

    for key in fv2_keys
        if fv1[key] == 0
            value = fv2[key]
            distance += value*value
        end
    end
    return sqrt(distance)
end

function infinite_dist(fv1::FeatureVector, fv2::FeatureVector)
    fv1_keys = keys(fv1)
    fv2_keys = keys(fv2)
    distance = 0
    current = 0

    for key in fv1_keys
        
        if key in fv2_keys
            current = abs(fv1[key]-fv2[key])
        else 
            current = abs(fv1[key])
        end

        if current > distance
            distance = current
        end
    end

    for key in fv2_keys
        if fv1[key] == 0
            current = fv2[key]
        end

        if current > distance
            distance = current
        end
    end
    return distance
end