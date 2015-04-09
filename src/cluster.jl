type Cluster <: FeatureSpace
  vectors::Dict{Any, FeatureVector}
  vector_sum::FeatureVector
  mdata::Any
  Cluster() = new(Dict{Any,FeatureVector}(),FeatureVector())
end

# returns FeatureVector indexed by [key]
function getindex(c::Cluster, key)
  return c.vectors[key]
end

# maps a [key] to a FeatureVector [fv] 
function setindex!(c::Cluster, fv::FeatureVector, key)
  if haskey(c, key)
    subtract!(c.vector_sum,c[key])
  end
  add!(c.vector_sum,fv)
  c.vectors[key] = fv
end

function haskey(c::Cluster, key) 
  return Base.haskey(c.vectors, key)
end

function length(c::Cluster)
  return Base.length(c.vectors)
end

# returns all keys in the cluster
function keys(c::Cluster)
  return Base.keys(c.vectors)
end

# returns all FeaturVectors in the cluster
function values(c::Cluster)
  return Base.values(c.vectors)
end

# check to see if the Cluster is empty.
function isempty(c::Cluster)
  return Base.isempty(c.vectors)
end

# returns cluster centroid
function centroid(c::Cluster)
  return c.vector_sum/length(c)
end

# returns the distance between the centroids of the provided clusters
function distance(c1::Cluster, c2::Cluster, dist::Function = dist_cos)
  return dist(centroid(c1),centroid(c2))
end

# average distance to centroid
function dist_centroid(cluster::Cluster, dist_func::Function=dist_euclidean, norm::Bool=true)
  features = values(cluster.vectors)
  cluster_avg_dist = 0
  cent = centroid(cluster)
  for fv in features
    if dist_func == dist_euclidean
      cluster_avg_dist += dist_func(cent,fv,norm)^2
    else
      cluster_avg_dist += dist_func(cent,fv,norm)
    end
  end
  return (cluster_avg_dist/length(features))
end

# creates distance matrix for a cluster
function dist_matrix(cluster::Cluster, dist_func::Function=dist_euclidean, norm::Bool=true, write_csv::Bool=false)
  len = length(cluster)
  dmatrix = Array(Number,(len,len))
  fvs = collect(keys(cluster))
  for i in [1:len]
    for j in [i:len]
      if i == j
        dmatrix[i,j] = 0
      else
        dist = dist_func(cluster[fvs[i]],cluster[fvs[j]],norm)
        dmatrix[i,j] = dist
        dmatrix[j,i] = dist
      end
    end
  end
  
  if write_csv
    f = open(join(["matrix_",string(dist_cos),".cvs"],""), "w")
    write(f, string(dist_func))
    for fv in fvs[1:len]
      write(f,join(["\t",string(fv)],""))
    end
    write(f,"\n")
    for i in [1:len]
      write(f,string(fvs[i]))
      for j in [1:len]
        write(f,join(["\t",string(dmatrix[i,j])],""))
      end
      write(f,"\n")
    end
    close(f)
  end

  return dmatrix
end

# prints out the cluster cleanly.
function display(cl::Cluster)
  print_with_color(:white,string(typeof(cl)))
  k = length(cl)

  print_with_color(:white," with $k FeatureVectors")
  if k > 0
    print_with_color(:white,":\n")
    if k > 5
      k = 5
    end

    for key in collect(keys(cl))[1:k]
      l = length(cl[key])
      if length(key) > 40
        key = key[1:40]
        key = key*"…"
      end
      print_with_color(:white,"    $key with $l features\n")
    end
    if length(cl) > 5
      print_with_color(:white,"\t\t\t⋮\n")
    end
  end
end

function show(io::IO, cl::Cluster)
  print(io,string(typeof(cl)))
  k = length(cl.vectors)
  print(io," with $k FeatureVectors")
end
