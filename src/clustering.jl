

#TODO
function hclust(data, dist)
end

function kmeans(clust::Dict, k=1, dist_func=cos_similarity, max_iter=10000)
	# find initial k centroids
	rand_num = (abs(rand(Int64)%Base.length(clust)) + 1)
	features = Base.values(clust)
	orig_cent = collect(features)[rand_num]
	centroids = vcat(orig_cent)
	cents_to_be_found = k-1
	while cents_to_be_found > 0
		best_dist = 0
		next_cent = FeatureVector()
		for fv in features
			current_min_max_dist = Inf
			for centroid in centroids
				min_max_dist = dist_func(centroid,fv)
				if min_max_dist < current_min_max_dist
					current_min_max_dist = min_max_dist
				end
			end
			if current_min_max_dist > best_dist
				best_dist = current_min_max_dist
				next_cent = fv
			end
		end
		centroids = vcat(centroids,next_cent)
		cents_to_be_found -= 1
	end

	# make Array of k clusters
	new_clusters = vcat()
	for centroid in centroids
		new_clusters = vcat(new_clusters, Cluster())
	end

	# find distance between fv and centroid
	iteration = 1
	no_change = false
	while !no_change && iteration < max_iter
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
			min_dist_cluster[i] = fv
			i += 1
		end

		# recompute new clusters
		old_centroids = centroids
		new_centroids = vcat()
		for cluster in new_clusters
			new_cent = centroid(cluster)
			new_centroids = vcat(new_centroids, new_cent)
		end		

		# checking if centroids moved.
		no_change = true
		i = 1
		for centroid in old_centroids
			dist = dist_func(centroid,new_centroids[i])
			if dist > .000001
				no_change = false
				centroids = new_centroids
				break
			end
			i += 1
		end

		# reset clusters if there are no changes.
		if !no_change
			new_clusters = vcat()
			for centroid in centroids
				new_clusters = vcat(new_clusters, Cluster())
			end
		end
		iteration += 1
	end


	return new_clusters
end 

