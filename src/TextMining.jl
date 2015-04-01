module TextMining

using ASCIIPlots, LightXML

import Base: getindex, setindex!, isempty, keys, values,
    copy, length, haskey, display

abstract FeatureSpace

include("feature_vector.jl")
include("cluster.jl")
include("data_set.jl")
include("clustering.jl")
include("distribution.jl")
include("text_processing.jl")

export  #types 
  Cluster, DataSet, Distribution, FeatureSpace, FeatureVector,
  
  #functions
  #classification
  knn, 
  #cluster
  centroid, distance, 
  #clustering
  random_init, max_min_init, kmeans, elbow_method,
  #data set
  #distribution
  probability, features, entropy, info_gain, perplexity,
  remove_smoothing!, delta_smoothing!, goodturing_smoothing!
  #feature vector
  sanitize!, freq_list, find_common_type, add!, subtract!, 
  multiply!, divide!, rationalize!, dist_cos, dist_zero,
  dist_zero_weighted, dist_taxicab, dist_euclidean, dist_infinite,
  #text processing
  clean, parse_xml, load_featurevector, load_cluster, load_dataset

end