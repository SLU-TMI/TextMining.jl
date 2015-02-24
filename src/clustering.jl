#TODO
function hclust(data, dist)
end


function random_init(features,k)
  features = shuffle!(features)
  centroids = Array(FeatureVector,k)
  while k > 0
    centroids[k] = features[k]
    k-=1
  end
  return centroids
end
random_init(features,k,dist_func) = random_init(features,k)

function max_min_init(features,k,dist_func)
  rand_num = (abs(rand(Int64)%Base.length(features)) + 1)
  orig_cent = features[rand_num]
  centroids = vcat(orig_cent)
  cents_to_be_found = k-1
  while cents_to_be_found > 0
    max_min_dist = 0
    next_cent = FeatureVector()
    for fv in features
      min_dist = Inf
      for centroid in centroids
        cent_dist = dist_func(centroid,fv)
        if cent_dist < min_dist
          min_dist = cent_dist
        end
      end
      if min_dist > max_min_dist
        max_min_dist = min_dist
        next_cent = fv
      end
    end
    centroids = vcat(centroids,next_cent)
    cents_to_be_found -= 1
  end
  return centroids
end

function kmeans(clust::Dict, cents::Array=[], k=1, init_cent_func=max_min_init, dist_func=cos_dist, max_iter=10000)
  # find initial k centroids
  features = collect(Base.values(clust))
  clust_keys = collect(Base.keys(clust))
  
  # check if user sent in own array of centroids
  if Base.length(cents) == 0
    centroids = init_cent_func(features,k,dist_func)
  else
    centroids = cents
    length_array = Base.length(centroids)
    if k > length_array
      Base.warn("The k($k) you entered is bigger than the amount of centroids in the array, reverting k to $length_array")
    end
  end

  # make Array of k clusters
  new_clusters = []
  for centroid in centroids
    new_clusters = vcat(new_clusters, Cluster())
  end

  # find distance between fv and centroid
  iteration = 1
  changed = true
  while changed && iteration < max_iter
    println(iteration)
    i = 1
    for fv in features
      dist = Inf
      j = 1
      min_dist_cluster = Cluster()
      for cluster in new_clusters
        current_dist = dist_func(centroids[j],fv)
        if current_dist < dist
          dist = current_dist
          min_dist_cluster = cluster
        end
        j += 1
      end
      min_dist_cluster[clust_keys[i]] = fv
      i+=1
    end

    # recompute new centroids
    old_centroids = centroids
    new_centroids = Array(typeof(centroid(new_clusters[1])),length(centroids))
    x = 1
    for cluster in new_clusters
      new_cent = centroid(cluster)
      new_centroids[x] = new_cent
      x+=1
    end		

    # checking if centroids moved.
    changed = false
    i = 1
    for centroid in old_centroids
      dist = dist_func(centroid,new_centroids[i])
      if dist > .000001
        changed = true
        centroids = new_centroids
        break
      end
      i += 1
    end

    # reset clusters if there are no changed.
    if changed
      new_clusters = []
      for centroid in centroids
        new_clusters = vcat(new_clusters, Cluster())
      end
    end
    iteration += 1
  end

  return new_clusters
end 
kmeans(clust::Dict, k, init_cent_func, dist_func) = kmeans(clust,[],k,init_cent_func,dist_func)
kmeans(clust::Dict, k, dist_func) = kmeans(clust,[],k,dist_func)
kmeans(clust::Dict, k, init_cent_func) = kmeans(clust,[],k,init_cent_func)
kmeans(clust::Dict, k) = kmeans(clust,[],k)



