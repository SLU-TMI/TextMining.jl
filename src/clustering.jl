#TODO
function hclust(data, dist)
end

#TODO
function kmeans(k::Integer, clust::Dict) = kmeans(k,clust,cos_simularity(),10000)
function kmeans(k::Integer, clust::Dict, max_iter::Integer) = kmeans(k,clust,cos_simularity(),max_iter)
function kmeans(k::Integer, clust::Dict, dist_func::Function) = kmeans(k,clust,dist_func,10000)

function kmeans(k::Integer, clust::Dict, dist_func::Function, max_iter::Integer)
	centroids = find_centroids(k,clust,dist_func)

	# array of centroids,features
	for centroid in centroids
		new_clusters = vcat(Cluster(Dict(),centroid))
	end
	new_clusters = find_distances(new_clusters, dist_func, features)
	return new_clusters
end 

function find_distances(clusters::Array,dist_func::Function,features)
	iteration = 1
	# noChange = false
	# while (!noChange && iteration < max_iter)
		# for fv in features
			# dist = Inf
			# for cluster in clusters
				# current_dist = dist_func(cluster.centroid,fv)
				# if current_dist < dist
					# dist = current_dist
					# cluster = cluster
				# end
			# end
			# cluster.clust = Dict(vcat(collect(values(cluster.clust)),fv))
		# end

		# recompute

		# check if difference

		# if not done reset clusters


		iteration++
	# end


	for fv in features
		min_dist = 0
		for centroid in centroids
			dist = dist_func(centroid,fv)
			if dist < min_dist
				current_centroid = centroid

	end

end


function find_centroids(k::Integer, clust::Dict, dist_func::Function)
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
				if fv.map == centroid.map
					continue
				else
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
		numCent = randomNumber
		cents_to_be_found--;
	end
	return centroids
end











































# function find_sec_cent(centroid, dist_func::Function, features)
# 	dist = 0
# 	for fv in features
# 		max_dist = dist
# 		dist = dist_func(centroid,fv)
# 		if dist > max_dist
# 			max_dist = dist
# 			sec_cent = fv
# 		end
# 	end
# 	return vcat(centroid,sec_cent)
# end

# function find_next_cent(centroids, dist_func::Function, features)
# 	max_min_dist = 0
# 	for fv in features
# 		min_dist = Inf
# 		for centroid in centroids
# 			dist = dist_func(centroid,fv)
# 			if dist < min_dist
# 				min_dist = dist
# 				if min_dist > max_min_dist
# 					max_min_dist = min_dist
# 					next_cent = fv
# 				end
# 			end
# 		end
# 	end
# 	return vcat(centroids,next_cent)
# end




