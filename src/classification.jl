function knn(k::Integer, data::DataSet, un_class_fv::FeatureVector, dist_func::Function)
  # get neighbors
  distances = Array((Number,Any),length(data))
  classifications = collect(keys(data))
  i = 1
  for class in classifications
    for fv in data[class].vectors
      distances[i] = dist_func(un_class_fv,fv[2]), class
      i += 1
    end
  end

  neighbors = FeatureVector()
  Base.sort!(distances)
  for x in 1:k
    neighbors[distances[x][2]] += 1
  end

  class_name = ""
  majority = 0
  for class in keys(neighbors)
    if neighbors[class] > majority
      majority = neighbors[class]
      class_name = class
    end
  end

  return class_name
end