println("**********Testing Clustering**********")

facts("Random init provides k initial centroids") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>0]))
  b = FeatureVector(Dict(["hello"=>0, "word"=>5]))
  c = FeatureVector(Dict(["hello"=>8, "word"=>4]))
  d = FeatureVector(Dict(["hello"=>4, "word"=>8]))
  e = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  f = FeatureVector(Dict(["jello"=>4, "kim"=>0]))
  dict = Dict([1=>a,2=>b,3=>c,4=>d,5=>e,6=>f])
  features = collect(Base.values(dict))
  centroids = random_init(features,2)

  @fact Base.length(centroids) => 2
  @fact centroids[1] != centroids[2] => true
end 

facts("Max-min init provides k initial distinct centroids") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>0]))
  b = FeatureVector(Dict(["hello"=>0, "word"=>5]))
  c = FeatureVector(Dict(["hello"=>8, "word"=>4]))
  d = FeatureVector(Dict(["hello"=>4, "word"=>8]))
  e = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  f = FeatureVector(Dict(["jello"=>4, "kim"=>0]))
  dict = Dict([1=>a,2=>b,3=>c,4=>d,5=>e,6=>f])
  features = collect(Base.values(dict))
  centroids = max_min_init(features,3,cos_dist)

  @fact Base.length(centroids) => 3
  @fact centroids[1] != centroids[2] => true
  @fact centroids[1] != centroids[3] => true
  @fact centroids[2] != centroids[3] => true
end 

facts("Max-min init provides a random centroid and its furthest centroid") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>0]))
  b = FeatureVector(Dict(["hello"=>0, "word"=>5]))
  c = FeatureVector(Dict(["hello"=>8, "word"=>4]))
  d = FeatureVector(Dict(["hello"=>4, "word"=>8]))
  e = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  f = FeatureVector(Dict(["jello"=>4, "kim"=>0]))
  dict = Dict([1=>a,2=>b,3=>c,4=>d,5=>e,6=>f])
  features = collect(Base.values(dict))
  centroids = max_min_init(features,2,cos_dist)

  for fv in features
    @fact cos_dist(centroids[1], centroids[2]) >= cos_dist(centroids[1],fv) => true
  end
end 

facts("kmeans returns correct amount of clusters") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>0]))
  b = FeatureVector(Dict(["hello"=>0, "word"=>5]))
  c = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  dict = Dict([1=>a,2=>b,3=>c])
  clusters = kmeans(dict,[],3)

  @fact Base.length(clusters) => 3
end 

facts("kmeans returns no empty clusters") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>0]))
  b = FeatureVector(Dict(["hello"=>0, "word"=>5]))
  c = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  dict = Dict([1=>a,2=>b,3=>c])
  clusters = kmeans(dict,[],3)

  for cluster in clusters
    @fact cluster.vectors != Cluster().vectors => true
  end
end


facts("kmeans returns the correct clustering of features") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>3]))
  b = FeatureVector(Dict(["part"=>3, "science"=>5]))
  c = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  aa = FeatureVector(Dict(["hello"=>7, "word"=>5]))
  bb = FeatureVector(Dict(["part"=>8, "science"=>9]))
  cc = FeatureVector(Dict(["kim"=>2, "julia"=>3]))
  aaa = FeatureVector(Dict(["hello"=>1, "word"=>3]))
  bbb = FeatureVector(Dict(["part"=>3, "science"=>1]))
  ccc = FeatureVector(Dict(["kim"=>15, "julia"=>12]))
  dict = Dict([1=>a,2=>b,3=>c,4=>aa,5=>bb,6=>cc,7=>aaa,8=>bbb,9=>ccc])
  clusters = kmeans(dict,[],3)

  # what the clusters should be
  clust1_values = [a,aa,aaa]
  clust2_values = [b,bb,bbb]
  clust3_values = [c,cc,ccc]
  array = [clust1_values,clust2_values,clust3_values]

  # getting each cluster's FVs and making sure they are all there.
  for cluster in clusters
    fvs = collect(Base.values(cluster.vectors))
    for value in fvs
      @fact value in array => true
    end
  end
end 


facts("kmeans lets you put in array of pre-defined centroids") do
  a = FeatureVector(Dict(["hello"=>4, "word"=>3]))
  b = FeatureVector(Dict(["part"=>3, "science"=>5]))
  c = FeatureVector(Dict(["kim"=>4, "julia"=>8]))
  aa = FeatureVector(Dict(["hello"=>7, "word"=>5]))
  bb = FeatureVector(Dict(["part"=>8, "science"=>9]))
  cc = FeatureVector(Dict(["kim"=>2, "julia"=>3]))
  aaa = FeatureVector(Dict(["hello"=>1, "word"=>3]))
  bbb = FeatureVector(Dict(["part"=>3, "science"=>1]))
  ccc = FeatureVector(Dict(["kim"=>15, "julia"=>12]))
  dict = Dict([1=>a,2=>b,3=>c,4=>aa,5=>bb,6=>cc,7=>aaa,8=>bbb,9=>ccc])
  array = [a,b,c]
  clusters = kmeans(dict,array)

  # what the clusters should be
  clust1_values = [a,aa,aaa]
  clust2_values = [b,bb,bbb]
  clust3_values = [c,cc,ccc]
  array = [clust1_values,clust2_values,clust3_values]

  # getting each cluster's FVs and making sure they are all there.
  for cluster in clusters
    fvs = collect(Base.values(cluster.vectors))
    for value in fvs
      @fact value in array => true
    end
  end
end 












