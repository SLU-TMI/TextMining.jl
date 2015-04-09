module TextMining

using ASCIIPlots, LightXML

import Base: getindex, setindex!, isempty, keys, values,
             copy, length, haskey, display, show

abstract FeatureSpace

include("feature_vector.jl")
include("cluster.jl")
include("data_set.jl")
include("clustering.jl")
include("distribution.jl")
include("text_processing.jl")
include("tree.jl")

export  
  #types 
  Cluster, DataSet, Distribution, FeatureSpace, FeatureVector, 
  BinaryTree, BinaryTreeNode, EmptyTree,
  
  
  #functions
  
  #classification
  knn,
  
  #cluster
  centroid, distance, dist_centroid, dist_matrix,
  
  #clustering
  random_init, max_min_init, kmeans, elbow_method, hclust,
  
  #data set
  
  #distribution
  probability, prob_fv, prob_cl, cond_prob_f_given_fv, 
  cond_prob_f_given_fv, cond_prob_f_given_clust, cond_prob_fv_given_clust, 
  features, entropy, fv_entropy, clust_entropy, #=fv_info_gain_clust,
  fv_info_gain_dataset, clust_info_gain_dataset, info_gain,=# perplexity, 
  remove_smoothing!, delta_smoothing!, goodturing_smoothing!,

  
  #feature vector
  sanitize!, freq_list, find_common_type, add!, subtract!, 
  multiply!, divide!, rationalize!, dist_cos, dist_zero,
  dist_zero_weighted, dist_taxicab, dist_euclidean, dist_infinite,
  
  #text processing
  clean, parse_xml, load_featurevector, load_cluster, load_dataset,
  get_metadata

end
