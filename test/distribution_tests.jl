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

facts("entropy of certain fv or clust") do
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

  c1_dist = Distribution(c1)
  c2_dist = Distribution(c2)
  ds_dist = Distribution(ds)

  @fact fv_entropy(c1_dist) => 1
  @fact fv_entropy(ds_dist) => 2
  @fact fv_entropy(ds_dist, "c1") => 1
  @fact clust_entropy(ds_dist) => 1
end

facts("Testing prob_* functions") do
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

  c1_dist = Distribution(c1)
  ds_dist = Distribution(ds)

  @fact prob_fv(c1_dist, "fv1") => 4/8
  @fact prob_fv(ds_dist, "c1", "fv1") => 4/16
  @fact prob_cl(ds_dist, "c1") => 8/16
end

facts("Testing cond_prob_* functions") do
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

  c1_dist = Distribution(c1)
  ds_dist = Distribution(ds)

  @fact cond_prob_f_given_fv(c1_dist, "fv1", "d") => 1/4
  @fact cond_prob_f_given_fv(ds_dist, "c2", "fva", "3") => 1/4
  @fact cond_prob_f_given_clust(ds_dist, "c1", "f") => 1/8
  @fact cond_prob_fv_given_clust(ds_dist, "c2", "fva") => 4/8
end

facts("info_gain(Distribution,Distribution) returns 0 if empty Distributions") do
  d1 = Distribution{FeatureVector}()
  d2 = Distribution{FeatureVector}()

  @fact info_gain(d1,d2) => 0
end

facts("chi_info_gain rules out similar features over all decades and outliers that wouldn't tell us much") do
  fv1 = FeatureVector(["the"=>5, "c1"=>5])
  fv2 = FeatureVector(["the"=>5, "c1"=>5, "romeo"=>100])
  fv3 = FeatureVector(["the"=>5, "c1"=>5])
  fv4 = FeatureVector(["the"=>5, "c1"=>5])
  fv5 = FeatureVector(["the"=>5, "c2"=>5])
  fv6 = FeatureVector(["the"=>5, "c2"=>5])
  fv7 = FeatureVector(["the"=>5, "c2"=>5])
  fv8 = FeatureVector(["the"=>5, "c2"=>5])
  fv9 = FeatureVector(["the"=>5, "c3"=>5])
  fv10 = FeatureVector(["the"=>5, "c3"=>5])
  fv11 = FeatureVector(["the"=>5, "c3"=>5])
  fv12 = FeatureVector(["the"=>5, "c3"=>5])
  fv13 = FeatureVector(["the"=>5, "c4"=>5])
  fv14 = FeatureVector(["the"=>5, "c4"=>5])
  fv15 = FeatureVector(["the"=>5, "c4"=>5])
  fv16 = FeatureVector(["the"=>5, "c4"=>5])

  c1 = Cluster()
  c2 = Cluster()
  c3 = Cluster()
  c4 = Cluster()

  c1["fv1"] = fv1
  c1["fv2"] = fv2
  c1["fv3"] = fv3
  c1["fv4"] = fv4
  c2["fv5"] = fv5
  c2["fv6"] = fv6
  c2["fv7"] = fv7
  c2["fv8"] = fv8
  c3["fv9"] = fv9
  c3["fv10"] = fv10
  c3["fv11"] = fv11
  c3["fv12"] = fv12
  c4["fv13"] = fv13
  c4["fv14"] = fv14
  c4["fv15"] = fv15
  c4["fv16"] = fv16

  ds = DataSet()

  ds["c1"] = c1
  ds["c2"] = c2
  ds["c3"] = c3
  ds["c4"] = c4

  d = Distribution(ds)  

  for feature in keys(d.space.vector_sum)
    if feature == "the" || feature == "romeo"
      @fact chi_info_gain(d,feature) => 0.0
    else
      @fact chi_info_gain(d,feature) => 2.0
    end
  end
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
  dict3 = ["the" => 15, "of" => 16, "what" => 1, "a" => 1, "unique" => 1, "word" => 1, "twice" => 2, "two" => 2, "party" => 2, "three" => 3]
  fv3 = FeatureVector(dict3)
  d3 = Distribution(fv3)
  goodturing_smoothing!(d3)
  @fact probability(d3,"word") => (((1+1)*(3/4))/44)
  @fact probability(d3,"twice") => (((2+1)*(1/3))/44)
  @fact probability(d3,"three") => (((3+1)*(0/1))/44)
  @fact probability(d3,"unk") => (4/44) 

  #removing smoothing
  remove_smoothing!(d1)
  @fact probability(d1,"word") => (7/20)
  @fact probability(d1,"another") => (13/20)
  @fact probability(d1,"unk") => (0/20)
end
