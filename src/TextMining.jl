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
include("naive_bayes.jl")
include("tree.jl")

export  
  #types 
  Cluster, DataSet, Distribution, FeatureSpace, FeatureVector, 
  BinaryTree, BinaryTreeNode, EmptyTree,
  
  
  #functions

  #naive bayes
  get_probs_fv_in_clust, split_dataset, separate_by_class, naive_bayes, 
  train_data, percentages,
  
  #classification
  knn,
  
  #cluster
  centroid, distance, dist_centroid, dist_matrix,
  
  #clustering
  random_init, max_min_init, kmeans, elbow_method, hclust,
  
  #data set
  
  #distribution
  get_num_texts_in_dist, get_num_texts_given_feature, probability, prob_fv, 
  prob_cl, cond_prob_f_given_fv, cond_prob_f_given_fv, cond_prob_f_given_fv_in_clust, 
  cond_prob_f_given_clust, cond_prob_fv_given_clust, prob_clust_in_dataset, 
  prob_clust_given_feature, features, entropy, fv_entropy, clust_entropy, 
  feature_entropy, clust_in_dataset_entropy, clust_given_feature_entropy, clust_info_gain, 
  chi_info_gain, feature_info_gain, info_gain, perplexity, remove_smoothing!, 
  delta_smoothing!, goodturing_smoothing!,

  
  #feature vector
  sanitize!, freq_list, find_common_type, add!, subtract!, 
  multiply!, divide!, rationalize!, dist_cos, dist_zero,
  dist_zero_weighted, dist_taxicab, dist_euclidean, dist_infinite,
  
  #text processing
  clean, parse_xml, load_featurevector, load_cluster, load_dataset,
  get_metadata

end
