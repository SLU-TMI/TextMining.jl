using TextMining

function get_probs(d::Distribution{DataSet})
  data_set = d.space
  probability_dict = Dict()
  for clust_name in keys(data_set.clusters)
    clust = d.space[clust_name]
    probability_dict[clust_name] = 0
    for fv in keys(clust.vectors)
    probability_dict[clust_name] += prob_fv(d,clust_name,fv)
    end
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
    println(i)
  end

  test_set = Array(Any, convert(Int64,((length(dataset)-i) +1)))
  j = 1
  for text in dataset[i:end]
    test_set[j] = text
    j+=1
  end

  return (train_set,test_set)
end

function separate_by_class(ds::DataSet)
  classes = Array(Any, length(ds.clusters))
  i = 1
  for clust_name in keys(ds.clusters)
    classes[i] = clust_name
    i+=1
  end
  return classes
end