println("**********Testing Clustering**********")

facts("Run hclust on multiple FeatureVectors") do

  a = FeatureVector(Dict(["pickle"=>1, "wand"=>10]))
  b = FeatureVector(Dict(["word"=>131, "war"=>5]))
  c = FeatureVector(Dict(["saint"=>8, "waffle"=>44]))
  d = FeatureVector(Dict(["kid"=>97, "taco"=>18]))
  e = FeatureVector(Dict(["krap"=>49, "sock"=>22]))
  f = FeatureVector(Dict(["sack"=>201, "chartreuse"=>30]))
  g = FeatureVector(Dict(["knack"=>201, "balls"=>30]))
  i = FeatureVector(Dict(["snot"=>1, "falcon"=>2, "water"=>19]))
  j = FeatureVector(Dict(["fart"=>13, "snot"=>50, "calculator"=>11]))
  k = FeatureVector(Dict(["waffle"=>8, "feather"=>41, "water"=>19]))
  l = FeatureVector(Dict(["nard"=>197, "knock"=>45, "phanome"=>9]))
  m = FeatureVector(Dict(["knock"=>73, "sock"=>20, "butter"=>1]))
  n = FeatureVector(Dict(["knee"=>20, "falcon"=>300, "France"=>45]))
  o = FeatureVector(Dict(["snot"=>1, "falcon"=>2, "wrench"=>9, "taco"=>74]))
  p = FeatureVector(Dict(["fart"=>13, "snot"=>50, "water"=>74, "or"=>194]))
  q = FeatureVector(Dict(["waffle"=>8, "feather"=>41, "chartreuse"=>24, "pickle"=>6]))
  r = FeatureVector(Dict(["nard"=>197, "knock"=>45, "superhotdogmission"=>1, "androgyny"=>4]))
  s = FeatureVector(Dict(["knock"=>73, "sock"=>20, "taco"=>35, "hoop"=>16]))
  t = FeatureVector(Dict(["knee"=>20, "falcon"=>300, "fresh"=>88, "prince"=>88]))
  u = FeatureVector(Dict(["snot"=>1, "falcon"=>1, "wrench"=>1, "taco"=>1, "prince"=>1]))
  v = FeatureVector(Dict(["fart"=>1, "snot"=>1, "water"=>1, "or"=>1, "prince"=>1]))
  w = FeatureVector(Dict(["waffle"=>1, "feather"=>1, "chartreuse"=>1, "pickle"=>1, "prince"=>1]))
  x = FeatureVector(Dict(["nard"=>1, "knock"=>1, "superhotdogmission"=>1, "androgyny"=>1, "prince"=>1]))
  y = FeatureVector(Dict(["knock"=>1, "sock"=>1, "taco"=>35, "hoop"=>1, "prince"=>1]))
  z = FeatureVector(Dict(["knee"=>1, "falcon"=>1, "fresh"=>1, "prince"=>1, "princes"=>1]))

  data = [a,b,c,d,e,f,g,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]
  h = hclust(data)
  @fact isa(h,BinaryTree) => true

end

facts("hclust deals returns nothing on incorrect input") do
  @fact hclust(3456787) => nothing
  @fact hclust("taco sauce") => nothing
  @fact hclust((4,5)) => nothing
end

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
  centroids = max_min_init(features,3,dist_cos)

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
  centroids = max_min_init(features,2,dist_cos)

  for fv in features
    @fact dist_cos(centroids[1], centroids[2]) >= dist_cos(centroids[1],fv) => true
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












