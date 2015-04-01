println("**********Testing Distribution**********")

facts("Creating a Distribution") do
  fv = FeatureVector()
  c = Cluster()
  ds = DataSet()
  d1 = Distribution(fv)
  d2 = Distribution(c)
  d3 = Distribution(ds)

  @fact typeof(d1) => Distribution{FeatureVector}
  @fact typeof(d2) => Distribution{Cluster}
  @fact typeof(d3) => Distribution{DataSet}
end

facts("If sent in with a FeatureVector, d.total is set") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  d1 = Distribution(fv1)

  @fact d1.total => 7
end

facts("Get probability of seeing feature in Distribution") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  d1 = Distribution(fv1)

  value = probability(d1,"word")

  @fact value => 4/7
end

facts("Get features of Distribution") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  d1 = Distribution(fv1)

  @fact features(d1) => keys(d1.space)
end

facts("Check isempty on a Distribution") do
  d1 = Distribution{FeatureVector}()
  d2 = Distribution{Cluster}()
  d3 = Distribution{DataSet}()

  @fact isempty(d1) => isempty(d1.space)
  @fact isempty(d2) => isempty(d2.space)
  @fact isempty(d3) => isempty(d3.space)
end

facts("entropy(Distribution) returns 0 if empty Distribution") do
  d1 = Distribution{FeatureVector}()

  @fact entropy(d1) => 0
end

facts("entropy(Distribution) returns entropy of Distribution") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  d1 = Distribution(fv1)

  @fact entropy(d1) => 0.9852281360342515
end

facts("entropy of different Distribution types") do
  fv1 = FeatureVector(["c"=>1,"b"=>1,"a"=>1,"d"=>1])
  fv2 = FeatureVector(["f"=>1,"g"=>1,"e"=>1,"h"=>1])
  fva = FeatureVector(["1"=>1,"2"=>1,"3"=>1,"4"=>1])
  fvb = FeatureVector(["8"=>1,"7"=>1,"6"=>1,"5"=>1])

  c1 = Cluster()
  c2 = Cluster()
  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c2["fva"] = fva
  c2["fvb"] = fvb

  ds = DataSet()
  ds["c1"] = c1
  ds["c2"] = c2

  fv1_dist = Distribution(fv1)
  fv2_dist = Distribution(fv2)
  fva_dist = Distribution(fva)
  fvb_dist = Distribution(fvb)
  c1_dist = Distribution(c1)
  c2_dist = Distribution(c2)
  ds_dist = Distribution(ds)

  @fact entropy(fv1_dist) => 2
  @fact entropy(fv2_dist) => 2
  @fact entropy(fva_dist) => 2
  @fact entropy(fvb_dist) => 2
  @fact entropy(c1_dist) => 3
  @fact entropy(c2_dist) => 3
  @fact entropy(ds_dist) => 4
end


facts("info_gain(Distribution,Distribution) returns 0 if empty Distributions") do
  d1 = Distribution{FeatureVector}()
  d2 = Distribution{FeatureVector}()

  @fact info_gain(d1,d2) => 0
end

facts("info_gain(Distribution,Distribution) returns info_gain of Distribution") do
  dict1 = ["word" => 4, "another" => 3]
  fv1 = FeatureVector(dict1)
  d1 = Distribution(fv1)

  dict2 = ["∂" => .1, "happy" => .3]
  fv2 = FeatureVector(dict2)
  d2 = Distribution(fv2)

  @fact info_gain(d1,d2) => 0.17395001157511858
end

facts("Smoothing FeatureVector has correct probabilties before and after") do
  dict1 = ["word" => 7, "another" => 13]
  fv1 = FeatureVector(dict1)
  d1 = Distribution(fv1)

  #no smoothing
  @fact probability(d1,"word") => (7/20)
  @fact probability(d1,"another") => (13/20)
  @fact probability(d1,"unk") => (0/20)
  
  #delta smoothing
  delta_smoothing!(d1)
  @fact probability(d1,"word") => (8/(3+20))
  @fact probability(d1,"another") => (14/(3+20))
  @fact probability(d1,"unk") => (1/(3+20))

  #good-turing smoothing
#=  dict3 = ["the" => 15, "of" => 16, "what" => 1, "a" => 1, "unique" => 1, "word" => 1, "twice" => 2, "two" => 2, "party" => 2, "three" => 3]
  fv3 = FeatureVector(dict3)
  d3 = Distribution(fv3)
  goodturing_smoothing!(d3)
  @fact probability(d3,"word") => (((1+1)*(3/4))/44)
  @fact probability(d3,"twice") => (((2+1)*(1/3))/44)
  @fact probability(d3,"three") => (((3+1)*(0/1))/44)
  @fact probability(d3,"unk") => (4/44) 
=#
  #removing smoothing
  remove_smoothing!(d1)
  @fact probability(d1,"word") => (7/20)
  @fact probability(d1,"another") => (13/20)
  @fact probability(d1,"unk") => (0/20)
end
