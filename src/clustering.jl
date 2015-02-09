#TODO
function hclust(data, dist)
end

#TODO
function kmeans(k::Integer, clust::Dict) = kmeans(k,clust,cos_simularity(),10000)
function kmeans(k::Integer, clust::Dict, max_iter::Integer) = kmeans(k,clust,cos_simularity(),max_iter)
function kmeans(k::Integer, clust::Dict, dist_func::Function) = kmeans(k,clust,dist_func,10000)

function kmeans(k::Integer, clust::Dict, dist_func::Function, max_iter::Integer)
	# find initial centroids
	rand_num = abs(rand(Int64)%Base.length(clust) + 1)
	features = values(clust)
	orig_cent = collect(features)[rand_num]
	centroids = vcat(orig_cent)
	cents_to_be_found = k-1
	while cents_to_be_found > 0
		best_dist = 0
		for fv in features
			current_min_max_dist = Inf
			for centroid in centroids
				if fv.map != centroid.map
					min_max_dist = dist_func(centroid,fv)
					if min_max_dist < current_min_max_dist
						current_min_max_dist = min_max_dist
					end
				end
			end
			if current_min_max_dist > bestDist
				bestDist = current_min_max_dist
				nextCent = fv
			end
		end
		centroids = vcat(centroids,nextCent)
		cents_to_be_found--;
	end

	# make Array of clusters
	for centroid in centroids
		new_clusters = vcat(new_clusters, Cluster())
	end

	# find distance between fv and centroid
	iteration = 1
	no_change = false
	while (!no_change) && (iteration < max_iter)
		i = 1
		for fv in features
			dist = Inf
			j = 1
			for centroid in centroids
				current_dist = dist_func(centroid,fv)
				if current_dist < dist
					dist = current_dist
					min_dist_cluster = new_clusters[j]
				end
			end
			min_dist_cluster[i] = fv
			i++
		end

		# recompute new clusters
		old_centroids = centroids
		i = 1
		new_centroids = vcat()
		for centroid in centroids
			cluster = new_clusters[i]
			new_centroids = vcat(new_centroids, cluster.centroid)
		end
		# set the new centroids
		centroids = new_centroids

		# checking if centroids moved.
		no_change = true
		for i = 0; i < k; i++
			dist = dist_func(old_centroids[i],new_centroids[i])
			if dist > .000001
				no_change = false
			end
		end

		# reset clusters if there are no changes.
		if (!no_change)
			new_clusters = vcat()
			for centroid in centroids
				new_clusters = vcat(new_clusters, Cluster())
			end
		end
		iteration++
	end


	return new_clusters
end 



