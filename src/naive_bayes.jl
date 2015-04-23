using TextMining

function get_probs_fv_in_clust(d::Distribution{DataSet})
  data_set = d.space
  probability_dict = Dict()
  for clust_name in keys(data_set.clusters)
    probability_dict[clust_name] = prob_clust_in_dataset(d,clust_name)
  end
  return probability_dict
end

# given an array of texts, split texts into training data and test data
function split_dataset(dataset::Array, ratio=.67)
  train_size = convert(Int64,ceil((length(dataset) * ratio)))
  train_set = Array(Any, train_size)
  dataset = shuffle!(dataset)
  i = 1
  while train_size > 0
    train_set[i] = dataset[i]
    i+=1
    train_size-=1
  end

  test_set = Array(Any, convert(Int64,((length(dataset)-i) +1)))
  j = 1
  for text in dataset[i:end]
    test_set[j] = text
    j+=1
  end

  return (train_set,test_set)
end

function separate_by_class(d::Distribution{DataSet})
  classes = Array(Any, length(d.space.clusters))
  i = 1
  for clust_name in keys(d.space.clusters)
    classes[i] = clust_name
    i+=1
  end
  return classes
end

function naive_bayes(d::Distribution{DataSet},fv::FeatureVector)

  class_probs = FeatureVector()
  for feature in keys(fv)
    for clust in keys(d.space.clusters)
      prob = prob_clust_given_feature(d,clust,feature)
      if isnan(prob) || prob == 0
        prob = 1e-15
      end
      class_probs[clust] += log(prob)*fv[feature]
    end
  end

  for clust in keys(d.space.clusters)
    prob = prob_clust_in_dataset(d,clust)
    class_probs[clust] += log(prob)
  end

  max_class = ""
  max_value = -Inf
  num_of_same_probs = 1
  for class in keys(class_probs)
    value = class_probs[class]
    if value > max_value
      max_class = class
      max_value = value
    elseif value == max_value
      num_of_same_probs += 1
    end
  end

  if num_of_same_probs == length(d.space.clusters)
    warn("All probabilities are the same value")
    return "unknown class"
  end

  return max_class
end

function train_data(ds::DataSet)
end









































