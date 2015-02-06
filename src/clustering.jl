#TODO
function hclust(data, dist)
end

#TODO
function kmeans(k::Integer, cluster::Dict) = kmeans(k,cluster,cos_simularity(),10000)
function kmeans(k::Integer, cluster::Dict, max_iter::Integer) = kmeans(k,cluster,cos_simularity(),max_iter)
function kmeans(k::Integer, cluster::Dict, dist_func::Function) = kmeans(k,cluster,dist_func,10000)

function kmeans(k::Integer, cluster::Dict, dist_func::Function, max_iter::Integer)
	rand_num = abs(rand(Int64)%Base.length(cluster) + 1)
	# cluster needs a dict?
	features = values(cluster)
	orig_cent = collect(features)[rand_num]
	k--
	if k > 1
		centroids = find_sec_cent(orig_cent, dist_func, features)
		k--
	end

	while k > 0
		centroids = find_next_cent(centroids,dist_func::Function,features)
		k--
	end

	for centroid in centroids
		new_clust = Cluster(Dict(),centroid)




end 

function find_sec_cent(centroid, dist_func::Function, features)
	dist = 0
	for fv in features
		max_dist = dist
		dist = dist_func(centroid,fv)
		if dist > max_dist
			max_dist = dist
			sec_cent = fv
		end
	end
	return vcat(centroid,sec_cent)
end

function find_next_cent(centroids, dist_func::Function, features)
	max_min_dist = 0
	for fv in features
		min_dist = Inf
		for centroid in centroids
		dist = dist_func(centroid,fv)
			if dist < min_dist
				min_dist = dist
				if min_dist > max_min_dist
					max_min_dist = min_dist
					next_cent = fv
				end
			end
		end
	end
	return vcat(centroids,next_cent)
end

function find_distances(cent::FeatureVector,dist_func::Function,length::Integer,features)
	clust = Dict()
	i = 1
	for fv in features
		clust[i] = dist_func(cent,fv)
		if maximum_dist < dist_array[i]
			maximum_dist = dist_array[i]
			next_cent = fv
		end
		i++
	end
	return dist_array
end














